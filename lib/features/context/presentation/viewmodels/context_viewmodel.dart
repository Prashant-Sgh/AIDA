import 'dart:core';

import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:aida/features/context/data_layer/repositories/context_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aida/features/context/data_layer/services/context_service.dart';
import 'package:aida/features/context/presentation/viewmodels/context_change_state.dart';
import 'package:aida/features/context/presentation/viewmodels/context_state.dart';
import 'package:aida/features/context/presentation/viewmodels/has_data_changed_result.dart';

final contextVMProvider = StateNotifierProvider<ContextViewModel, ContextState>(
  (ref) {
    final repo = ref.read(contextRepositoryProvider);
    final authVM = ref.read(authenticationViewModelProvider);
    return ContextViewModel(repo, authVM);
  },
);

class ContextViewModel extends StateNotifier<ContextState> {
  final ContextRepository _repository;
  // final AuthenticationViewModel _authVM;
  final AuthenticationState _authVM;

  String get userEmail => _authVM.email;

  ContextViewModel(
    ContextRepository repo,
    AuthenticationState authState,
  )   : _repository = repo,
        _authVM = authState,
        super(ContextState());

  ContextChangeState contextChangeState =
      ContextChangeState(hasDataChanged: false, isLoading: false, error: null);

  List<Map<String, ContextModel>> originalContextModels = [];
  List<Map<String, ContextModel>> changedContextModels = [];

  ContextModel newContextModel = ContextModel(id: '', name: '', content: '');

  void updateNewContextModel({String? name, String? content}) {
    newContextModel = newContextModel.copyWith(name: name, content: content);
    debugPrint('New context model changed to: ${newContextModel.toJson()}');
  }

  void clearNewContextModel() =>
      newContextModel = newContextModel.copyWith(id: '', name: '', content: '');

  bool get hasDataChanged => contextChangeState.hasDataChanged;

  // -----------------------------
  // Update Methods
  // -----------------------------
  void stackInLatestChanges({
    required String index,
    required ContextModel latestContext,
  }) {
    changedContextModels
        .where((element) => element.containsKey(index))
        .first
        .update(index, (_) => latestContext);

    contextChangeState = contextChangeState.copyWith(hasDataChanged: true);
  }

  // -----------------------------
  // CRUD - Create Methods
  // -----------------------------
  Future<ResponseState> createContext(
      {required ContextModel newContext}) async {
    state = state.copyWith(creating: true, error: null);
    ResponseState responseState =
        await _repository.create(newContextModel: newContext, email: userEmail);
    state = state.copyWith(
        creating: false,
        error: responseState == ResponseState.error
            ? 'Context could not be created'
            : null);
    return responseState;
  }

  // -----------------------------
  // CRUD - Fetch Methods
  // -----------------------------
  Future<void> loadContexts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final email = _authVM.email;
      // _authVM.email;
      final data = await _repository.getContexts(emailId: email);
      debugPrint('Loading context for email : $email');
      if (data is List<ContextModel>) {
        state = state.copyWith(allContexts: data, isLoading: false);

        originalContextModels =
            data.map((context) => {context.id: context}).toList();
      } else {
        state = state.copyWith(
            isLoading: false,
            error: '204 No Content → request succeeded but returned empty data',
            errorCode: 204);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -----------------------------
  // CRUD - Query Methods
  // -----------------------------
  ContextModel getContextById({required String id}) {
    return state.allContexts.firstWhere((contexts) => contexts.id == id);
  }

  // -----------------------------
  // CRUD - Update Methods
  // -----------------------------
  Future<ContextChangeState> updateContextModels() async {
    state = state.copyWith(updating: true, error: null);
    final updatedModels = _hasDataChanged(
        originalContextModels: originalContextModels,
        changedContextModels: changedContextModels);

    if (!updatedModels.hasChanged) {
      state = state.copyWith(updating: false, error: null);
      return ContextChangeState(
          hasDataChanged: false, isLoading: false, error: null);
    }

    contextChangeState =
        contextChangeState.copyWith(isLoading: true, error: null);

    try {
      for (var modifiedContext in updatedModels.changedModels) {
        final contextData = modifiedContext.values.first;
        await _repository.updateContext(
            newContextModel: contextData, emailId: userEmail);
      }

      contextChangeState = contextChangeState.copyWith(
          hasDataChanged: false, isLoading: false, error: null);
      state = state.copyWith(updating: false, error: null);
      return contextChangeState;
    } catch (e) {
      contextChangeState = contextChangeState.copyWith(
        hasDataChanged: true,
        isLoading: false,
        error: e.toString(),
      );
      state = state.copyWith(updating: false, error: e.toString());
      return contextChangeState;
    }
  }

  // -----------------------------
  // CRUD - Update Methods
  // -----------------------------

  Future<ResponseState> updateContext(
      {required ContextModel updatedContext}) async {
    state = state.copyWith(updating: true, error: null);
    final response = await _repository.updateContext(
        newContextModel: updatedContext, emailId: userEmail);
    state = state.copyWith(
        updating: false,
        error: response == ResponseState.error
            ? 'Context could not be updated'
            : null);
    return response;
  }

  // -----------------------------
  // CRUD - Delete Methods
  // -----------------------------
  Future<ResponseState> deleteById({required String contextId}) async {
    state = state.copyWith(deleting: true, error: null);
    final response = await _repository.deleteContextWithId(
        contextId: contextId, emailId: userEmail);
    state = state.copyWith(
        deleting: false,
        error: response == ResponseState.error
            ? 'Context could not be deleted'
            : null);
    return response;
  }
}

HasDataChangedResult _hasDataChanged({
  required List<Map<String, ContextModel>> originalContextModels,
  required List<Map<String, ContextModel>> changedContextModels,
}) {
  bool hasChanged = false;
  final changedModels = <Map<String, ContextModel>>[];

  for (var changedContext in changedContextModels) {
    final correspondingContextModel = originalContextModels.firstWhere(
      (originalContext) =>
          originalContext.containsKey(changedContext.keys.first),
      orElse: () => {},
    );

    if (correspondingContextModel.isNotEmpty) {
      final changed = changedContext.values.first;
      final original = correspondingContextModel.values.first;

      if (changed.content != original.content) {
        hasChanged = true;
        changedModels.add(changedContext);
      }
    }
  }

  return HasDataChangedResult(
    hasChanged: hasChanged,
    changedModels: changedModels,
  );
}

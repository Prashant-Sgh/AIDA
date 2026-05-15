import 'dart:core';

import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:aida/features/context/data_layer/repositories/context_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aida/features/context/data_layer/services/context_service.dart';
import 'package:aida/features/context/presentation/viewmodels/context_change_state.dart';
import 'package:aida/features/context/presentation/viewmodels/context_state.dart';
import 'package:aida/features/context/presentation/viewmodels/has_data_changed_result.dart';

final contextVMProvider = NotifierProvider<ContextViewModel, ContextState>(
  ContextViewModel.new,
);

class ContextViewModel extends Notifier<ContextState> {
  late final ContextRepository _repository;

  @override
  ContextState build() {
    _repository = ref.read(contextRepositoryProvider);
    return ContextState(); // initial state
  }

  ContextChangeState contextChangeState =
      ContextChangeState(hasDataChanged: false, isLoading: false, error: null);

  List<Map<String, ContextModel>> originalContextModels = [];
  List<Map<String, ContextModel>> changedContextModels = [];

  ContextModel newContextModel = ContextModel(id: '', name: '', content: '');

  void updateNewContextModel({String? name, String? content}) {
    newContextModel = newContextModel.copyWith(name: name, content: content);
    debugPrint(
        'New context model changed to: ' + newContextModel.toJson().toString());
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
        await _repository.create(newContextModel: newContext);
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
      final data = await _repository.getContexts();
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
        await _repository.updateContext(newContextModel: contextData);
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
    final response =
        await _repository.updateContext(newContextModel: updatedContext);
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
  Future<ResponseState> deleteById({required String id}) async {
    state = state.copyWith(deleting: true, error: null);
    final response = await _repository.deleteContextWithId(id: id);
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

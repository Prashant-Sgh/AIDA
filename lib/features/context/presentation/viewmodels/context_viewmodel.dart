import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aida/features/context/data_layer/services/firestore_service.dart';
import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:aida/features/context/presentation/viewmodels/context_change_state.dart';
import 'package:aida/features/context/presentation/viewmodels/context_state.dart';
import 'package:aida/features/context/presentation/viewmodels/has_data_changed_result.dart';

final contextVMProvider = NotifierProvider<ContextViewModel, ContextState>(
  ContextViewModel.new,
);

class ContextViewModel extends Notifier<ContextState> {
  late final FirestoreServices _service;

  // State tracking
  ContextChangeState contextChangeState =
      ContextChangeState(hasDataChanged: false, isLoading: false, error: null);

  List<Map<String, ContextModel>> originalContextModels = [];
  List<Map<String, ContextModel>> latestContextModels = [];

  @override
  ContextState build() {
    _service = FirestoreServices();
    return ContextState(); // initial state
  }

  // -----------------------------
  // Update Methods
  // -----------------------------
  void stackInLatestChanges({
    required String index,
    required ContextModel latestContext,
  }) {
    latestContextModels
        .where((element) => element.containsKey(index))
        .first
        .update(index, (_) => latestContext);
  }

  Future<ContextChangeState> updateContextModels() async {
    final hasDataChangedResult =
        _hasDataChanged(originalContextModels, latestContextModels);

    if (!hasDataChangedResult.hasChanged) {
      return ContextChangeState(hasDataChanged: false, isLoading: false, error: null);
    }

    contextChangeState = contextChangeState.copyWith(isLoading: true, error: null);

    try {
      for (var modifiedContext in hasDataChangedResult.newContextModels) {
        final contextData = modifiedContext.values.first;
        await _service.updateContext(context: contextData);
      }

      contextChangeState = contextChangeState.copyWith(isLoading: false, error: null);
      return contextChangeState;
    } catch (e) {
      contextChangeState = contextChangeState.copyWith(
        hasDataChanged: true,
        isLoading: false,
        error: e.toString(),
      );
      return contextChangeState;
    }
  }

  // -----------------------------
  // Fetch Methods
  // -----------------------------
  Future<void> loadContexts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _service.getContexts();
      state = state.copyWith(allContexts: data, isLoading: false);

      originalContextModels = data.map((context) => {context.id: context}).toList();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -----------------------------
  // Query Methods
  // -----------------------------
  ContextModel getContextById({required String id}) {
    return state.allContexts.firstWhere((contexts) => contexts.id == id);
  }
}

HasDataChangedResult _hasDataChanged(
  List<Map<String, ContextModel>> originalContextModels,
  List<Map<String, ContextModel>> latestContextModels,
) {
  bool hasChanged = false;
  final newContextModels = <Map<String, ContextModel>>[];

  for (var latestContextModel in latestContextModels) {
    final correspondingContextModel = originalContextModels.firstWhere(
      (originalContext) =>
          originalContext.containsKey(latestContextModel.keys.first),
      orElse: () => {},
    );

    if (correspondingContextModel.isNotEmpty) {
      final latest = latestContextModel.values.first;
      final original = correspondingContextModel.values.first;

      if (latest.content != original.content || latest.name != original.name) {
        hasChanged = true;
        newContextModels.add(latestContextModel);
      }
    }
  }

  return HasDataChangedResult(
    hasChanged: hasChanged,
    newContextModels: newContextModels,
  );
}


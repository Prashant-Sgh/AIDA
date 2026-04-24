import 'package:aida/features/context/presentation/viewmodels/context_state.dart';
import 'package:aida/features/context/data_layer/services/firestore_service.dart';
import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contextVMProvider = NotifierProvider<ContextViewModel, ContextState>(
  ContextViewModel.new,
);

class ContextViewModel extends Notifier<ContextState> {
  late final FirestoreService _service;

  @override
  ContextState build() {
    _service = FirestoreService();
    return ContextState(); // initial state
  }

  // Fetch data
  Future<void> loadContexts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _service.getContexts();

      state = state.copyWith(allContexts: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // get selected id's context
  ContextModel getContextById({required String id}) {
    final selectedContext = state.allContexts.firstWhere((contexts) => contexts.id == id);

    return selectedContext;
  }
}

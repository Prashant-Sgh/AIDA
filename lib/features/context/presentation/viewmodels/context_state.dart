import 'package:aida/features/context/domain_layer/context_model.dart';

class ContextState {
  final List<ContextModel> allContexts;
  final Set<String> selectedId;
  final bool isLoading;
  final String? error;

  ContextState({
    this.allContexts = const [],
    this.selectedId = const {},
    this.isLoading = false,
    this.error,
  });

  ContextState copyWith({
    List<ContextModel>? allContexts,
    Set<String>? selectedId,
    bool? isLoading,
    String? error,
  }) {
    return ContextState(
        allContexts: allContexts ?? this.allContexts,
        selectedId: selectedId ?? this.selectedId,
        isLoading: isLoading ?? this.isLoading,
        error: error);
  }
}

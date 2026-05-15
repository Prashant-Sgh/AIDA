import 'package:aida/features/context/data_layer/model/context_model.dart';

class ContextState {
  final List<ContextModel> allContexts;
  final Set<String> selectedId;
  final bool isLoading;
  final bool creating;
  final bool updating;
  final bool deleting;
  final String? error;
  final int? errorCode;

  ContextState({
    this.allContexts = const [],
    this.selectedId = const {},
    this.isLoading = false,
    this.creating = false,
    this.updating = false,
    this.deleting = false,
    this.error,
    this.errorCode,
  });

  ContextState copyWith({
    List<ContextModel>? allContexts,
    Set<String>? selectedId,
    bool? isLoading,
    bool? creating,
    bool? updating,
    bool? deleting,
    String? error,
    int? errorCode,
  }) {
    return ContextState(
      allContexts: allContexts ?? this.allContexts,
      selectedId: selectedId ?? this.selectedId,
      isLoading: isLoading ?? this.isLoading,
      creating: creating ?? this.creating,
      updating: updating ?? this.updating,
      deleting: deleting ?? this.deleting,
      error: error,
      errorCode: errorCode,
    );
  }
}

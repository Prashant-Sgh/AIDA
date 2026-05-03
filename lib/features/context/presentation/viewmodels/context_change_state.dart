class ContextChangeState {
  bool hasDataChanged;
  bool isLoading = false;
  String? error;

  ContextChangeState(
      {required this.hasDataChanged,
      required this.isLoading,
      required this.error});

  ContextChangeState copyWith(
      {bool? hasDataChanged, bool? isLoading, String? error}) {
    return ContextChangeState(
      hasDataChanged: hasDataChanged ?? this.hasDataChanged,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

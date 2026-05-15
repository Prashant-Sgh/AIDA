import 'package:aida/features/context/data_layer/model/context_model.dart';

class HasDataChangedResult {
  bool hasChanged;
  List<Map<String, ContextModel>> changedModels;

  HasDataChangedResult({required this.hasChanged, required this.changedModels});

  HasDataChangedResult copyWith(
      {bool? hasChanged = false,
      List<Map<String, ContextModel>>? changedModels = const []}) {
    return HasDataChangedResult(
        hasChanged: hasChanged ?? this.hasChanged,
        changedModels: changedModels ?? this.changedModels);
  }
}

import 'package:aida/features/context/domain_layer/context_model.dart';

class HasDataChangedResult {
  bool hasChanged;
  List<Map<String, ContextModel>> newContextModels;

  HasDataChangedResult(
      {required this.hasChanged, required this.newContextModels});

  HasDataChangedResult copyWith(
      {bool? hasChanged = false,
      List<Map<String, ContextModel>>? newContextModels = const []}) {
    return HasDataChangedResult(
        hasChanged: hasChanged ?? this.hasChanged,
        newContextModels: newContextModels ?? this.newContextModels);
  }
}

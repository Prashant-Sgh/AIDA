import 'package:aida/features/context/domain_layer/context_model.dart';

class FirestoreService {
  Future<List<ContextModel>> getContexts() async {
    return [
      ContextModel(id: '1', name: 'Context 1', content: 'Content for context 1'),
      ContextModel(id: '2', name: 'Context 2', content: 'Content for context 2'),
      ContextModel(id: '3', name: 'Context 3', content: 'Content for context 3'),
      ContextModel(id: '4', name: 'Context 4', content: 'Content for context 4'),
    ];
  }
}

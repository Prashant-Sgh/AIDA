import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/context/data_layer/services/context_service.dart';
import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contextRepositoryProvider = Provider<ContextRepository>(
  (ref) => ContextRepository(ref.read(contextServiceProvider)),
);

class ContextRepository {
  final ContextServices _contextService;

  ContextRepository(this._contextService);

  Future<ResponseState> create(ContextModel newContextModel) async {
    ResponseState responseState =
        await _contextService.createContext(newContext: newContextModel);
    return responseState;
  }

  Future<List<ContextModel>> getContexts() async {
    final contexts = await _contextService.getContexts();
    if (contexts == null)
      return [
        ContextModel(
            id: 'Error_ ID',
            name: 'No context loaded',
            content: 'No context loaded')
      ];
    return contexts;
  }

  Future<ResponseState> updateContext({required ContextModel newContextModel}) async {
    final state = await _contextService.updateContext(context: newContextModel);
    return state;
  }

  Future<ResponseState> deleteContextWithId({required String id}) async {
    final state = await _contextService.deleteById(id: id);
    return state;
  }
}

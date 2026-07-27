import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/context/data_layer/services/context_service.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contextRepositoryProvider = Provider<ContextRepository>(
  (ref) => ContextRepository(ref.read(contextServiceProvider)),
);

class ContextRepository {
  final ContextServices _contextService;

  ContextRepository(this._contextService);

  Future<ResponseState> create(
      {required ContextModel newContextModel, required String email}) async {
    ResponseState responseState = await _contextService.createContext(
        context: newContextModel, email: email);
    return responseState;
  }

  Future<List<ContextModel>?> getContexts({required String emailId}) async {
    final contexts = await _contextService.getContexts(emailId: emailId);
    // if (contexts == null) throw Exception('Could not get contexts');
    return contexts;
  }

  Future<ResponseState> updateContext(
      {required ContextModel newContextModel, required String emailId}) async {
    final state = await _contextService.updateContext(
        context: newContextModel, emailId: emailId);
    return state;
  }

  Future<ResponseState> deleteContextWithId(
      {required String contextId, required String emailId}) async {
    final state = await _contextService.deleteById(
        contextId: contextId, emailId: emailId);
    return state;
  }
}

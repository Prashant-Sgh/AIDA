import 'package:aida/features/context/domain_layer/context_model.dart';

class FirestoreServices {
  
  Future<List<ContextModel>> getContexts() async {



    // return [
    //   ContextModel(
    //       id: '1',
    //       name: 'Context 1',
    //       content:
    //           'Hey, what kind of app Reloaded 1 of 1149 libraries in 4,160ms (compile: 547 ms, reload: 1314 ms, reassemble: 1754 ms). Reloaded 1 of 1149 libraries in 4,160ms (compile: 547 ms, reload: 1314 ms, reassemble: 1754 ms).'),
    //   ContextModel(
    //       id: '2', name: 'Context 2', content: 'Hey, what kind of app'),
    //   ContextModel(
    //       id: '3', name: 'Context 3', content: 'Hey, what kind of app'),
    //   ContextModel(
    //       id: '4', name: 'Context 4', content: 'Hey, what kind of app'),
    // ];
  }

  // Update context in Firestore
  Future<void> updateContext({
    required ContextModel context,
  }) async {
    // TODO - Implement Firestore update logic here
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    print(
        'Context with ID ${context.id} updated in Firestore with new data: ${context.toString()}');
  }
}

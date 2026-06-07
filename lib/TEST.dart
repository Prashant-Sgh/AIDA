// // import 'dart:convert';
// import 'dart:convert';

// import 'package:aida/features/chat/data/model/message.dart';
// import 'package:http/http.dart' as http;

// void main() async {
//   print('It\'s on work..  \n');

//   final loadConversation = await ChatRepo().loadConversation();

//   print("DONE");
// }

// class ChatRepo {
//   final String _baseUrl = 'aida-backend-three.vercel.app';
//   final headers = {
//     'Content-Type': 'application/json',
//     'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
//   };

//   Future<void> loadConversation(
//       // required String userEmail,
//       // required String conversationId,
//       ) async {
//     final uri = Uri.https(
//       _baseUrl,
//       '/ai/load-conversations',
//       {
//         'email': "test@aida.com",
//         "conversation_id": "SMW-Conversation_Testing_01"
//       },
//     );

//     try {
//       final response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         // print('Conversation fetched successfully: ${response.body}');
//         final data = jsonDecode(response.body);
//         // print('data: $data');
//         var conversations = [];
//         for (var d in data) {
//           final message = MessageObj.fromJson(d);
//           conversations.add(message);
//         }
//         print('\nConversations: $conversations');
//       } else {
//         print(
//             '\n Error code received: ${response.statusCode}, response body: ${response.body}');
//       }
//     } catch (error) {
//       print('\n Error fetching conversation: $error');
//     }
//   }
// }

// MessageObj messageObj = MessageObj();

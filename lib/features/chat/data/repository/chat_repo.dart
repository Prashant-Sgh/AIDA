import 'dart:convert';
import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepoProvider = Provider<ChatRepo>(
  (ref) => ChatRepo(),
);

class ChatRepo {
  final String _baseUrl = 'aida-backend-three.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
  };

  ResponseState _responseState = ResponseState.notInitiated;
  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  Future<String?> sendMessage({ required String message, required String email, required String conversationId}) async {
    final url = Uri.parse('$_baseUrl/ai/send-message');
    final body = jsonEncode({'message': message, 'email': email, 'conversation': conversationId});
    final headers = {
      'Content-Type': 'application/json',
      'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
    };

    updateResponseState(ResponseState.loading);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
        return response.body;
      } else {
        updateResponseState(ResponseState.error);
        return "Sorry... \nError: ${response.statusCode} + API call failed. \nPlease try again later.";
      }
    } catch (error) {
      updateResponseState(ResponseState.error);
      return "Bad Request or Server error happened. \nPlease try again later.";
    }
  }

  Future<List<MessageObj>?> loadConversation(
      {required String userEmail, required String conversationId}) async {
    final uri = Uri.https(
      _baseUrl,
      '/ai/load-conversations',
      {'email': userEmail, "conversation_id": conversationId},
    );

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<MessageObj> conversations = [];

        for (var d in data) {
          final message = MessageObj.fromJson(d);
          conversations.add(message);
        }
        debugPrint('Conversation fetched successfully: ${response.body}');
        return conversations;
      } else {
        debugPrint(
            'Error code ${response.statusCode} for fetching conversation: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error fetching conversation: $error');
    }
  }
}

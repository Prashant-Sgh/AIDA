import 'dart:convert';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/LocalDbManager.dart';
import 'package:http/http.dart' as http;

enum ResponseState { notInitiated, loading, success, error }

class MessageRepository {
  final String _baseUrl =
      'https://aida-backend-ee5qdr7fo-prashant-knows-projects.vercel.app';
  // final String _baseUrl = 'http://192.168.137.1:3000';

  ResponseState _responseState = ResponseState.notInitiated;

  DatabaseManager databaseManager = DatabaseManager();

  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  Future<String?> sendMessage(String message) async {
    final url = Uri.parse('$_baseUrl/send-message');
    final body = jsonEncode({'latestUserMessage': message});
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
        return "error: ${response.statusCode}";
      }
    } catch (error) {
      updateResponseState(ResponseState.error);
      return "error: $error";
    }
  }

  Future<List<MessageObj>> loadMessages() async {
    final messages = await databaseManager.loadMessages();
    return messages;
  }

  Future<void> deleteMessage(int messageId) async {
    databaseManager.deleteMessage();
  }

  Future<void> saveMessage(MessageObj newMessage) async {
    await databaseManager.saveMessage(newMessage);
  }
}

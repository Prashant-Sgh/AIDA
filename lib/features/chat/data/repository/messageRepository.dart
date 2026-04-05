import 'dart:convert';
// import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/repository/LocalDbManager.dart';
import 'package:http/http.dart' as http;

enum ResponseState { notInitiated, loading, success, error }

class MessageRepository {
  final String _baseUrl =
      'https://aida-backend-4077kwn3m-prashant-knows-projects.vercel.app';

  ResponseState _responseState = ResponseState.notInitiated;

  DatabaseManager databaseManager = DatabaseManager();

  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  void getResponseState() => _responseState;

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
        return "Sorry... \nError: ${response.statusCode} + API call failed. \nPlease try again later.";
      }
    } catch (error) {
      updateResponseState(ResponseState.error);
      return "Bad Request or Server error happened. \nPlease try again later.";
    }
  }

  Future<List<Conversation>> loadMessages() async {
    final messages = await databaseManager.loadMessages();
    return messages;
  }

  Future<void> saveMessage(Conversation newMessage) async {
    await databaseManager.saveMessage(newMessage);
  }

  Future<void> deleteMessage(String messageId) async {
    databaseManager.deleteMessage(messageId);
  }

  Future<void> clearChat() async {
    await databaseManager.clearChat();
  }
}

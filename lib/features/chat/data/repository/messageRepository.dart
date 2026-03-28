import 'dart:convert';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/LocalDbManager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ResponseState { notInitiated, loading, success, error }

class MessageRepository {
  // final String _baseUrl = 'http://localhost:3000';
  final String _baseUrl = 'http://192.168.137.1:3000';

  ResponseState _responseState = ResponseState.notInitiated;

  DatabaseManager databaseManager = DatabaseManager();

  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  Future<String?> sendMessage(String message) async {
    final url = Uri.parse('$_baseUrl/send-message');
    final body = jsonEncode({'latestUserMessage': message});
    // final headers = jsonEncode({'Content-Type': 'application/json'});
    final headers = jsonEncode({'Accept': '*/*'});

    updateResponseState(ResponseState.loading);
    try {
      print("Message is: request sent...");
      final response =
          await http.post(url, headers: {'Accept': '*/*'}, body: body);
      print("Message is: response received...");
      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
        print("Message is: status code 200");
        print("Message is: status code 200: ${response.body}");
        return jsonDecode(response.body);
      } else {
        updateResponseState(ResponseState.error);
        print("Message is: status code BAD");
        return "WTF*";
      }
    } catch (error) {
      updateResponseState(ResponseState.error);
      print("Message is: status code ERROR");
      return "WTF*";
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

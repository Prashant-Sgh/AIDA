import 'dart:convert';

import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:http/http.dart' as http;

class TEST {
  Future<String> getContexts() async {
    print('Simulating fetching contexts from Firestore...');
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return 'Code executed successfully';
  }

  final String _baseUrl =
      'http://localhost:3000/ai';

  Future<String?> sendMessage(String message) async {
    final url = Uri.parse('$_baseUrl/send-message');
    final body = jsonEncode({'latestUserMessage': message});
    final headers = {
      'Content-Type': 'application/json',
      // 'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Sorry... \nError: ${response.statusCode} + API call failed. The error: ${response.body} \nPlease try again later.";
      }
    } catch (error) {
      return "Bad Request or Server error happened. \nPlease try again later.";
    }
  }
}

void main() async {
  final testService = TEST();
  final sendMessageResult = await testService.sendMessage('Hello, this is a test message!');
  print(sendMessageResult);
}
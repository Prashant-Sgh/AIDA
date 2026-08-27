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
  List<String> followUpQuestions = [];
  final String _baseUrl = 'aida-backend-three.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
  };

  ResponseState _responseState = ResponseState.notInitiated;
  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  Future<String> sendMessage({
    required String message,
    required String email,
    required String conversationId,
  }) async {
    final url = Uri.parse('https://$_baseUrl/ai/send-message');
    final body = jsonEncode(
        {'message': message, 'email': email, 'conversation': conversationId});
    final headers = {
      'Content-Type': 'application/json',
      'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
    };

    updateResponseState(ResponseState.loading);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String answer = data['answer'] ?? '';
        final List<dynamic> suggestions = data['suggestions'] ?? [];
        followUpQuestions = suggestions.cast<String>();
        return answer;
      } else {
        updateResponseState(ResponseState.error);
        return "Sorry... something went wrong \nError code: ${response.statusCode}, \nError body: ${jsonDecode(response.body)} \n+ API call failed. \nPlease try again later.";
      }
    } catch (error) {
      //   debugPrint('Bad Request: ${error.toString()}');
      updateResponseState(ResponseState.error);
      return "Bad Request or Server error happened. \nPlease try again later.";
    }
  }

  Future<List<MessageObj>?> loadConversation({
    required String userEmail,
    required String conversationId,
  }) async {
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
        return conversations;
      } else {
        debugPrint(
            'Error code ${response.statusCode} for fetching conversation: ${response.body}');
        return null;
      }
    } catch (error) {
      debugPrint('Error fetching conversation: $error');
      return null;
    }
  }

  Stream<List<MessageObj>> streamConversations({
    required String userEmail,
    required String conversationId,
  }) async* {
    final client = http.Client();
    final uri = Uri.https(
      _baseUrl,
      '/ai/stream-conversations',
      {'email': userEmail, "conversation_id": conversationId},
    );

    try {
      final request = http.Request('GET', uri);
      request.headers.addAll(headers);
      
      final response = await client.send(request);
      
      if (response.statusCode == 200) {
        await for (final byte in response.stream.cast<List<int>>()) {
          final decoded = utf8.decode(byte);
          
          // SSE data lines start with "data: "
          final lines = decoded.split('\n');
          for (var line in lines) {
            if (line.startsWith('data: ')) {
              final jsonString = line.substring(6).trim();
              try {
                final List<dynamic> data = jsonDecode(jsonString);
                yield data.map((d) => MessageObj.fromJson(d)).toList();
              } catch (e) {
                debugPrint('SSE Decode Error: $e');
              }
            }
          }
        }
      } else {
        debugPrint('SSE Connection Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('SSE Stream Exception: $e');
    } finally {
      client.close();
    }
  }

  Future<void> clearConversation({
    required String email,
    required String conversationId,
  }) async {

        final uri = Uri.https(
      _baseUrl,
      '/ai/delete-conversation',
    );

    final body = jsonEncode({"email": email, "conversation_id": conversationId});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        debugPrint('Chat cleared successfully: ${response.body}');
      } else {
        debugPrint(
            'Error code ${response.statusCode} for clearing chat: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error clearing chat: $error');
    }
  }

  // ==================== GUEST USER METHODS ====================

  /// Sends a message as a guest user using sessionId
  Future<String> sendMessageGuest({
    required String message,
    required String sessionId,
  }) async {
    final url = Uri.parse('https://$_baseUrl/ai/guest/send-message');
    final body = jsonEncode({'message': message, 'sessionId': sessionId});

    updateResponseState(ResponseState.loading);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String answer = data['answer'] ?? '';
        final List<dynamic> suggestions = data['suggestions'] ?? [];
        followUpQuestions = suggestions.cast<String>();
        return answer;
      } else {
        updateResponseState(ResponseState.error);
        return "Sorry... something went wrong \nError code: ${response.statusCode}, \nError body: ${jsonDecode(response.body)} \n+ API call failed. \nPlease try again later.";
      }
    } catch (error) {
      updateResponseState(ResponseState.error);
      return "Bad Request or Server error happened. \nPlease try again later.";
    }
  }

  /// Loads conversation history for a guest user using sessionId
  Future<List<MessageObj>?> loadConversationGuest({
    required String sessionId,
  }) async {
    final uri = Uri.https(
      _baseUrl,
      '/ai/guest/load-conversations',
      {'sessionId': sessionId},
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
        return conversations;
      } else {
        debugPrint(
            'Error code ${response.statusCode} for fetching guest conversation: ${response.body}');
        return null;
      }
    } catch (error) {
      debugPrint('Error fetching guest conversation: $error');
      return null;
    }
  }

  /// Streams conversation for a guest user using sessionId
  Stream<List<MessageObj>> streamConversationsGuest({
    required String sessionId,
  }) async* {
    final client = http.Client();
    final uri = Uri.https(
      _baseUrl,
      '/ai/guest/stream-conversations',
      {'session_id': sessionId},
    );

    try {
      final request = http.Request('GET', uri);
      request.headers.addAll(headers);
      
      final response = await client.send(request);
      
      if (response.statusCode == 200) {
        await for (final byte in response.stream.cast<List<int>>()) {
          final decoded = utf8.decode(byte);
          
          // SSE data lines start with "data: "
          final lines = decoded.split('\n');
          for (var line in lines) {
            if (line.startsWith('data: ')) {
              final jsonString = line.substring(6).trim();
              try {
                final List<dynamic> data = jsonDecode(jsonString);
                yield data.map((d) => MessageObj.fromJson(d)).toList();
              } catch (e) {
                debugPrint('SSE Decode Error: $e');
              }
            }
          }
        }
      } else {
        debugPrint('SSE Connection Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('SSE Stream Exception: $e');
    } finally {
      client.close();
    }
  }

  /// Placeholder for clearing guest conversation - not implemented yet
  Future<void> clearConversationGuest({
    required String sessionId,
  }) async {
    // TODO: Implement when backend supports guest conversation clearing
    debugPrint('clearConversationGuest not yet implemented for sessionId: $sessionId');
    throw UnimplementedError('Guest conversation clearing not yet implemented');
  }
}

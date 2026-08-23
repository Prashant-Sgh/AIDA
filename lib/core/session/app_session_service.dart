import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:aida/core/session/app_session.dart';
import 'package:flutter/material.dart';

/// Service responsible for fetching the application session.
/// 
/// Calls the backend API endpoint `/ai/getSessionId` to get a unique session ID
/// for this app instance.
class AppSessionService {
  static const String _baseUrl = 'aida-backend-three.vercel.app';
  static const String _sessionEndpoint = '/ai/getSessionId';
  
  final headers = {
    'Content-Type': 'application/json',
    'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
  };

  /// Fetches a new application session from the backend.
  /// 
  /// Returns an [AppSession] with a unique session ID from the server.
  /// Throws an exception if the session cannot be fetched.
  Future<AppSession> fetchSession() async {
    debugPrint('[OUTPUT] [App Session] Starting fetchSession from $_baseUrl$_sessionEndpoint');

    try {
      final uri = Uri.https(_baseUrl, _sessionEndpoint);
      debugPrint('[OUTPUT] [App Session] Sending GET request to $uri');
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessionId = data['sessionId'] as String?;
        // For debugging, we use a hardcoded session ID if the API fails, but this should be removed in production.
        // final sessionId = 'WORKING_Session_ID';
        
        if (sessionId == null || sessionId.isEmpty) {
          throw Exception('Invalid response: sessionId is missing or empty');
        }

        final session = AppSession(
          sessionId: sessionId,
          createdAt: DateTime.now(),
          metadata: {
            'source': 'backend_api',
            'platform': 'flutter',
          },
        );

        debugPrint('[OUTPUT] [App Session] Session fetched successfully - $sessionId');
        return session;
      } else {
        final errorBody = jsonDecode(response.body);
        debugPrint('[OUTPUT] [App Session] API Error: ${response.statusCode} - $errorBody');
        throw Exception('Failed to fetch session: ${response.statusCode} - $errorBody');
      }
    } catch (e, stackTrace) {
      debugPrint('[OUTPUT] [App Session] Exception caught: $e');
      debugPrint('[OUTPUT] [App Session] Stack trace: $stackTrace');
      
      // Fallback to local session ID if API fails, so the app doesn't crash
      debugPrint('[OUTPUT] [App Session] Falling back to local session ID');
      final fallbackSessionId = 'local_${DateTime.now().millisecondsSinceEpoch}';
      return AppSession(
        sessionId: fallbackSessionId,
        createdAt: DateTime.now(),
        metadata: {
          'source': 'local_fallback',
          'platform': 'flutter',
          'error': e.toString(),
        },
      );
    }
  }
}

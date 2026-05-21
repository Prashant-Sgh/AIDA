import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:aida/core/enums/response_state.dart';
import 'package:http/http.dart' as http;

final backend2faServicesProvider = Provider<Backend2faServices>((ref) {
  return Backend2faServices();
});

class Backend2faServices {
  final String _baseUrl = 'aida-backend-three.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
  };

  Future<ResponseState> start2fa({required String token}) async {
    ResponseState responseState = ResponseState.notInitiated;
    final uri = Uri.https(
      _baseUrl,
      '/auth/start2fa',
    );

    final body = jsonEncode({"firebaseIdToken": token});

    responseState = ResponseState.loading;
    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        debugPrint(
            'Status code: ${response.statusCode}, response.message: ${response.body}');
        responseState = ResponseState.success;
      } else {
        debugPrint(
            'Status code: ${response.statusCode}, body: ${response.body}');
        responseState = ResponseState.error;
      }
    } catch (e) {
      debugPrint('BACKEND - ERROR: $e');
      responseState = ResponseState.error;
      throw Exception(e);
    }
    return responseState;
  }

  Future<void> sendOTP({required String email}) async {
    final uri = Uri.https(_baseUrl, '/auth/sendOtp');
    try {
      final response = await http.post(uri,
          headers: headers, body: jsonEncode({'email': email}));
      if (response.statusCode == 200) {
        debugPrint(
            'Status code: ${response.statusCode}, response.message: ${response.body}');
      } else {
        debugPrint(
            'Status code: ${response.statusCode}, response.message: ${response.body}');
      }
    } catch (e) {
      // debugdebugPrint('BACKEND - ERROR: $e');
      debugPrint('BACKEND - ERROR: $e');
      throw Exception(e);
    }
    // debugdebugPrint('OTP sent to $email');
  }

  Future<String> verifyOtp({required String otp, required String email}) async {
    final uri = Uri.https(_baseUrl, '/auth/verifyOtp');
    final body = jsonEncode({'otp': otp, 'uid': email});

    final response = await http.post(uri, headers: headers, body: body);
    final jwtToken = jsonDecode(response.body)['token'];

    if (response.statusCode == 200 && jwtToken != null && jwtToken is String) {
      debugPrint('Status code: ${response.statusCode}, Token: $jwtToken');
      return jwtToken;
    } else {
      debugPrint(
          'Status code: ${response.statusCode}, response.message: ${response.body}');
      return '';
    }
  }

  Future<bool> validateJwt({required String token}) async {
    // TODO: implement validateJwt
    return false;
  }
}

import 'dart:convert';

import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final contextServiceProvider = Provider(
  (ref) => ContextServices(),
);

class ContextServices {
  ResponseState _responseState = ResponseState.notInitiated;
  void getResponseState() => _responseState;
  void updateResponseState(ResponseState newState) {
    _responseState = newState;
  }

  // final String _baseUrl = 'localhost:3000';
  final String _baseUrl = 'aida-backend-three.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'x-vercel-protection-bypass': 'EVdAY3uz4Y2FsMNKsNMVLudVBt9yXzPh'
  };

  // Create
  Future<ResponseState> createContext(
      {required ContextModel newContext}) async {
    ResponseState responseState = ResponseState.notInitiated;

    final uri = Uri.parse('https://$_baseUrl/crud/create');
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    newContext = newContext.copyWith(id: id);
    final body = jsonEncode(newContext.toJson());

    try {
      responseState = ResponseState.loading;
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        responseState = ResponseState.success;
      } else {
        responseState = ResponseState.error;
      }
    } catch (e) {
      print('FIRESTORE - ' + e.toString());
      responseState = ResponseState.error;
    }

    return responseState;
  }

  // Read by ID
  Future<ContextModel?> getContextById({required String id}) async {
    final uri = Uri.http(
      _baseUrl,
      '/crud/readById',
      {'id': id},
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final ContextModel context = ContextModel.fromJson(data);
        return context;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  // Read
  Future<List<ContextModel>?> getContexts() async {
    final uri = Uri.https(
      _baseUrl,
      '/crud/readAll',
    );

    try {
      debugPrint('Getting contexts...');
      final response = await http.get(uri, headers: headers);

      debugPrint('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<ContextModel> contexts = [];

        for (var d in data) {
          final ContextModel context = ContextModel.fromJson(d);
          contexts.add(context);
        }
        return contexts;
      } else {
        debugPrint(
            'Error getting contexts, status code: ${response.statusCode}, body: ${response.body}');
        return null;
      }
    } catch (error) {
      debugPrint('Error getting contexts, error: $error');
      return null;
    }
  }

  // Update
  Future<ResponseState> updateContext({required ContextModel context}) async {
    ResponseState _responseState = ResponseState.notInitiated;

    final uri = Uri.parse('http://$_baseUrl/crud/update');
    final body = jsonEncode(context.toJson());

    try {
      updateResponseState(ResponseState.loading);
      final response = await http.put(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
      } else {
        updateResponseState(ResponseState.error);
      }
    } catch (e) {
      print('FIRESTORE - ERROR: $e');
      updateResponseState(ResponseState.error);
    }

    return _responseState;
  }

  // Delete context by id
  Future<ResponseState> deleteById({required String id}) async {
    ResponseState _responseState = ResponseState.notInitiated;

    final url = Uri.http(
      _baseUrl,
      '/crud/deleteById',
      {'id': id},
    );

    try {
      updateResponseState(ResponseState.loading);
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        updateResponseState(ResponseState.success);
      } else {
        updateResponseState(ResponseState.error);
      }
    } catch (e) {
      print('FIRESTORE - ERROR: $e');
      updateResponseState(ResponseState.error);
    }

    return _responseState;
  }
}

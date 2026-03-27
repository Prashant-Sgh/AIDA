import 'dart:async';
import 'dart:math';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart'as FlutterChatCore;

class MessageManager {
  final MessageRepository _messageRepository;

  MessageManager(this._messageRepository);

  List<FlutterChatCore.Message> _conversation = [];

  Stream<List<FlutterChatCore.Message>> get conversationStream => _conversationStreamController.stream;

  final _conversationStreamController = StreamController<List<FlutterChatCore.Message>>();

  Future<void> sendMessage(String message) async {
    await _messageRepository.sendMessage(message);
    _updateConversation(message, authorId: 'AIDA');
    _conversationStreamController.add(_conversation);
  }

  Future<List<Message>> getMessages() async {
    final messages = await _messageRepository.loadMessages();
    _conversation = messages.map((message) => FlutterChatCore.TextMessage.fromJson(message.toJson())).toList();
    _conversationStreamController.add(_conversation);
    return messages;
  }

  Future<void> deleteMessage(int messageId) async {
    await _messageRepository.deleteMessage(messageId);
    _conversation.removeWhere((message) => message.id == messageId);
    _conversationStreamController.add(_conversation);
  }

  void _updateConversation(String message, {required String authorId, DateTime? createdAt}) {
    final newMessage = FlutterChatCore.TextMessage(
      id: '${Random().nextInt(1000) + 1}',
      authorId: authorId,
      createdAt: createdAt ?? DateTime.now().toUtc(),
      text: message,
    );
    _conversation.insert(0, newMessage);
  }
}
import 'dart:async';
import 'dart:math';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageManager {
  final MessageRepository _messageRepository;

  MessageManager(this._messageRepository);

  List<types.Message> _conversation = [];

  final _conversationStreamController =
      StreamController<List<types.Message>>.broadcast();
  Stream<List<types.Message>> get conversationStream =>
      _conversationStreamController.stream;

  Future<void> sendMessage(String text) async {
    final userMessage = types.TextMessage(
      author: const types.User(id: 'user1'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '${Random().nextInt(1000000)}',
      text: text,
    );

    _conversation = [userMessage, ..._conversation];
    _conversationStreamController.add(_conversation);

    await _messageRepository.saveMessage(MessageObj(
      id: userMessage.id,
      authorId: userMessage.author.id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(userMessage.createdAt!),
      text: text,
    ));

    final response = await _messageRepository.sendMessage(text);
    if (response != null) {
      final aiMessage = types.TextMessage(
        author: const types.User(id: 'AIDA'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '${Random().nextInt(1000000)}',
        text: response,
      );
      _conversation = [aiMessage, ..._conversation];
      _conversationStreamController.add(_conversation);

      await _messageRepository.saveMessage(MessageObj(
        id: aiMessage.id,
        authorId: aiMessage.author.id,
        createdAt: DateTime.fromMillisecondsSinceEpoch(aiMessage.createdAt!),
        text: response,
      ));
    }
  }

  Future<void> loadConversations() async {
    final messages = await _messageRepository.loadMessages();
    _conversation = messages.map((m) {
      return types.TextMessage(
        author: types.User(id: m.authorId),
        createdAt: m.createdAt?.millisecondsSinceEpoch,
        id: m.id,
        text: m.text ?? '',
      );
    }).toList();

    // Sort by createdAt descending (newest first) for flutter_chat_ui
    _conversation
        .sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

    _conversationStreamController.add(_conversation);
  }

  Future<void> deleteMessage(String messageId) async {
    // Note: The repository currently deletes ALL messages.
    // You might want to update messageRepository.deleteMessage to take an ID.
    await _messageRepository.deleteMessage(
        messageId); // Dummy ID for now as per repo implementation
    _conversation.removeWhere((message) => message.id == messageId);
    _conversationStreamController.add(_conversation);
  }

  Future<void> clearChat() async {
    await _messageRepository
        .clearChat(); // Dummy ID for now as per repo implementation
    _conversation.clear();
    _conversationStreamController.add(_conversation);
  }
}

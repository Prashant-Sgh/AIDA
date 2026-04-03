import 'dart:async';
import 'dart:math';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageManager {
  final MessageRepository _messageRepository;

  MessageManager(this._messageRepository);

  List<Conversation> _conversation = [];

  final _conversationStreamController =
      StreamController<List<Conversation>>.broadcast();
  Stream<List<Conversation>> get conversationStream =>
      _conversationStreamController.stream;

  Future<void> sendMessage(String text) async {
    final userMessage = Conversation(
      isUser: true,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      id: '${Random().nextInt(1000000)}',
      message: text,
    );

    _conversation = [userMessage, ..._conversation];
    _conversationStreamController.add(_conversation);

    await _messageRepository.saveMessage(Conversation(
      id: userMessage.id,
      time: userMessage.time,
      isUser: userMessage.isUser,
      message: userMessage.message,
    ));

    final response = await _messageRepository.sendMessage(text);
    if (response != null) {
      final aiMessage = Conversation(
        isUser: false,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        id: '${Random().nextInt(1000000)}',
        message: response,
      );
      _conversation = [aiMessage, ..._conversation];
      _conversationStreamController.add(_conversation);

      await _messageRepository.saveMessage(Conversation(
        id: aiMessage.id,
        isUser: aiMessage.isUser,
        time: aiMessage.time,
        message: response,
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

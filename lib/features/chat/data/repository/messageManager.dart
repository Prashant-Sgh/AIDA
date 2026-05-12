import 'dart:async';
import 'dart:math';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageManagerProvider = Provider<MessageManager>(
    (ref) => MessageManager(ref.watch(messageRepositoryProvider)));

class MessageManager {
  final MessageRepository messageRepository;

  MessageManager(this.messageRepository);

  List<Conversation> _conversation = [];

  final _conversationStreamController =
      StreamController<List<Conversation>>.broadcast();
  Stream<List<Conversation>> get conversationStream =>
      _conversationStreamController.stream;

  get responseState => messageRepository.getResponseState();

  Future<void> sendMessage(String text) async {
    final userMessage = _createConversation(text, true);
    _conversation = [userMessage, ..._conversation];
    _conversationStreamController.add(_conversation);

    await messageRepository.saveMessage(userMessage);
    final response = await messageRepository.sendMessage(text);
    if (response != null) {
      final aiResponse = _createConversation(response, false);
      _conversation = [aiResponse, ..._conversation];
      _conversationStreamController.add(_conversation);
      await messageRepository.saveMessage(aiResponse);
    }
  }

  Future<void> loadConversations() async {
    final messages = await messageRepository.loadMessages();
    _conversation = messages.map((m) {
      return Conversation(
        isUser: m.isUser,
        time: m.time,
        id: m.id,
        message: m.message,
      );
    }).toList();

    // Sort by createdAt descending (newest first) for flutter_chat_ui
    _conversation.sort((a, b) =>
        (a.time ?? DateTime.now()).compareTo(b.time ?? DateTime.now()));
    // _conversation.sort((a, b) => (b.time ?? 0).compareTo(a.time ?? 0));

    _conversationStreamController.add(_conversation);
  }

  Future<void> deleteMessage(String messageId) async {
    // Note: The repository currently deletes ALL messages.
    // You might want to update messageRepository.deleteMessage to take an ID.
    await messageRepository.deleteMessage(
        messageId); // Dummy ID for now as per repo implementation
    _conversation.removeWhere((message) => message.id == messageId);
    _conversationStreamController.add(_conversation);
  }

  Future<void> clearChat() async {
    await messageRepository
        .clearChat(); // Dummy ID for now as per repo implementation
    _conversation.clear();
    _conversationStreamController.add(_conversation);
  }
}

Conversation _createConversation(String text, bool isUser) => Conversation(
      isUser: isUser,
      time: DateTime.now(),
      id: '${Random().nextInt(1000000)}',
      message: text,
    );

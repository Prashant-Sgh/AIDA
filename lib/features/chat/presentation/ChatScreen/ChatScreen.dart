import 'package:aida/features/chat/data/repository/messageManager.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Basic extends StatefulWidget {
  const Basic({super.key});

  @override
  BasicState createState() => BasicState();
}

class BasicState extends State<Basic> {
  final MessageManager messageManager = MessageManager(MessageRepository());
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
    messageManager.loadConversations();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatScrAppBar(),
        body: StreamBuilder<List<types.Message>>(
          stream: messageManager.conversationStream,
          builder: (context, snapshot) {
            final uiMessages = snapshot.data ?? [];

            // Map types.Message (flutter_chat_types) to Message (flutter_chat_core)
            final coreMessages = uiMessages.map((m) {
              if (m is types.TextMessage) {
                return Message.text(
                  id: m.id,
                  authorId: m.author.id,
                  createdAt: m.createdAt != null
                      ? DateTime.fromMillisecondsSinceEpoch(m.createdAt!)
                      : DateTime.now(),
                  text: m.text,
                );
              }
              // Fallback for unsupported types
              return Message.text(
                id: m.id,
                authorId: m.author.id,
                createdAt: DateTime.now(),
                text: '',
              );
            }).toList();

            // Reverse the list because flutter_chat_ui/core often expects
            // the oldest message at index 0 for its internal list management,
            // while we might be receiving newest first.
            // Check if your manager already sorts them correctly.
            // In MessageManager we sorted newest first (b.compareTo(a)).
            // InMemoryChatController.setMessages replaces the whole list.
            _chatController.setMessages(coreMessages.reversed.toList());

            return Chat(
              chatController: _chatController,
              currentUserId: 'user1',
              onMessageSend: (text) async {
                await messageManager.sendMessage(text);
              },
              resolveUser: (UserID id) async {
                return User(
                  id: id,
                  name: id == 'user1' ? 'Me' : 'AIDA',
                );
              },
              theme: ChatTheme.fromThemeData(Theme.of(context)),
            );
          },
        ),
      ),
    );
  }
}

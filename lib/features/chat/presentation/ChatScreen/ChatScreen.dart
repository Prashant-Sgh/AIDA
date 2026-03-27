import 'dart:math';

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
  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  // final _user = const types.User(id: 'user-1');
  // final _otherUser = const types.User(id: 'user-2');

  final List<Message> _messages = [
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'Hey there! 👋',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Hi Alice, how are you?',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'I’m good, just testing this chat UI package!',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Looks neat! Messages are showing up perfectly.',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'Hey there! 👋',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Hi Alice, how are you?',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'I’m good, just testing this chat UI package!',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Looks neat! Messages are showing up perfectly.',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'Hey there! 👋',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Hi Alice, how are you?',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user1',
      createdAt: DateTime.now().toUtc(),
      text: 'I’m good, just testing this chat UI package!',
    ),
    TextMessage(
      // Better to use UUID or similar for the ID - IDs must be unique
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'user2',
      createdAt: DateTime.now().toUtc(),
      text: 'Looks neat! Messages are showing up perfectly.',
    ),
  ];

  final _chatController = InMemoryChatController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatScrAppBar(),
        body: Chat(
          theme: ChatTheme.fromThemeData(Theme.of(context)),
          chatController: _chatController,
          currentUserId: 'user1',

          builders: Builders(),

          // onMessageSend: (text) {
          //   _chatController.insertAllMessages(_messages);
          //   _chatController.insertMessage(
          //     TextMessage(
          //       // Better to use UUID or similar for the ID - IDs must be unique
          //       id: '${Random().nextInt(1000) + 1}',
          //       authorId: 'user1',
          //       createdAt: DateTime.now().toUtc(),
          //       text: text,
          //     ),
          //   );
          // },
          
          resolveUser: (UserID id) async {
            return User(id: id, name: 'John Doe');
          },
        ),
      ),
    );
  }
}

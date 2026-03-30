import 'package:aida/features/chat/data/model/ConversationHandeler.dart';
import 'package:aida/features/chat/presentation/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/widget/ChatInputBar.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:aida/features/chat/presentation/widget/Conversations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends ConsumerState<ChatScreen> {
  final conversationHandler = ConversationHandeler();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: ChatScrAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: conversationHandler.conversations.isEmpty
                    ? Center(
                        child: ChatHint(),
                      )
                    : Conversations()),
            Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ChatInputBar(),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/ConversationHandeler.dart';
import 'package:aida/features/chat/data/repository/messageManager.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:aida/features/chat/presentation/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/widget/ChatInputBar.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:aida/features/chat/presentation/widget/Conversations.dart';
import 'package:aida/features/chat/presentation/widget/processingAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends ConsumerState<ChatScreen> {
  final conversationHandler = ConversationHandeler();
  final MessageManager _messageManager = MessageManager(MessageRepository());

  @override
  void initState() {
    super.initState();
    _messageManager.loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = 10.0;
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // final List<Conversations> _conversations = [
    //   Conversations(
    //       isUser: false, message: 'Hello! How can I assist you today?'),
    //   Conversations(isUser: true, message: 'I need help with my account.'),
    //   Conversations(
    //       isUser: false, message: 'Sure! What seems to be the issue?'),
    //   Conversations(isUser: true, message: 'I forgot my password.'),
    //   Conversations(
    //       isUser: false, message: 'No worries! I can help you reset it.'),
    //   Conversations(
    //       isUser: false, message: 'Hello! How can I assist you today?'),
    //   Conversations(isUser: true, message: 'I need help with my account.'),
    //   Conversations(
    //       isUser: false, message: 'Sure! What seems to be the issue?'),
    //   Conversations(isUser: true, message: 'I forgot my password.'),
    // ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: ChatScrAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
                stream: _messageManager.conversationStream,
                builder: (context, snapshot) {
                  final _conversations = snapshot.data ?? [];

                  final _coreConversations = _conversations.map((c) {
                    return Conversations(
                      id: c.id,
                      time: c.time,
                      isUser: c.isUser,
                      message: c.message,
                    );
                                    });

                  return Expanded(
                    child: _conversations.isEmpty
                        ? Center(
                            child: ChatHint(),
                          )
                        : ListView(
                            children: [
                              ..._coreConversations,
                              ProcessingAnimation(),
                            ],
                          ),
                  );
                }),
            // ProcessingAnimation(),
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

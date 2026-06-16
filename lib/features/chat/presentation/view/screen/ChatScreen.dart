import 'dart:io';

import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/presentation/view/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/view/widget/ChatInputBar.dart';
import 'package:aida/features/chat/presentation/view/widget/ChatScrAppBar.dart';
import 'package:aida/features/chat/presentation/view/widget/Conversations.dart';
import 'package:aida/features/chat/presentation/view/widget/processingAnimation.dart';
import 'package:aida/features/chat/presentation/viewmodel/chat_viewmodel.dart';
import 'package:aida/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends ConsumerState<ChatScreen> {
  // late final MessageManager _messageManager;
  late final ChatViewmodel chatVM;
  bool _isExiting = false;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    super.initState();
    chatVM = ref.read(chatVMProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatVM.loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatVMProvider);

    // final bottomInset = 10.0;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 100) {
        setState(() => _showScrollToBottomButton = true);
      } else {
        setState(() => _showScrollToBottomButton = false);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: ChatScrAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_isExiting) return false;

            // showDialog returns a value. Capture it in 'shouldPop'
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    'Leaving so soon?',
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  content: Text(
                    'Your chat will be right here when you come back.',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'Stay',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Exit',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // If the user picked 'Exit', kill the app process
            if (shouldPop == true) {
              setState(() => _isExiting = true);
              exit(0);
            }

            // ALWAYS return false here to prevent the automatic pop
            return false;
          },
          child: Column(
            children: [
              StreamBuilder(
                  stream: chatVM.conversationStream,
                  builder: (context, snapshot) {
                    final conversations =
                        snapshot.data ?? Conversation(messages: [MessageObj()]);

                    final coreConversations = conversations.messages.map((c) {
                      return Conversations(
                        messageObj: c,
                      );
                    });

                    return Expanded(
                      child: chatState.isEmpty
                          ? Center(
                              child: ChatHint(),
                            )
                          : Stack(
                              children: [
                                ListView(
                                  controller: _scrollController,
                                  children: [
                                    ...coreConversations,
                                    if (chatState.isWaitingForResponse)
                                      ProcessingAnimation(),
                                  ],
                                ),
                                if (_showScrollToBottomButton)
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_downward_rounded,
                                            size: 14,
                                            color: theme.colorScheme.surface),
                                        onPressed: () {
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOutSine,
                                          );
                                        },
                                        splashRadius: 22,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(bottom: bottomInset + 10),
                child: ChatInputBar(
                  sendMessage: (it) => chatVM.sendMessage(it),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: AppDrawer(
        onClearChat: chatVM.clearChat,
      ),
    );
  }
}

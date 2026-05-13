import 'dart:io';

import 'package:aida/core/enums/response_state.dart';
import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/chat/data/repository/messageManager.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:aida/features/chat/presentation/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/widget/ChatInputBar.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:aida/features/chat/presentation/widget/Conversations.dart';
import 'package:aida/features/chat/presentation/widget/processingAnimation.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:aida/shared/functionalities/showConfirmationDialog.dart';
import 'package:aida/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends ConsumerState<ChatScreen> {
  late final MessageManager _messageManager;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _messageManager = ref.read(messageManagerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageManager.loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final bottomInset = 10.0;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: ChatScrAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_isExiting) return false;

            // showDialog returns a value. Capture it in 'shouldPop'
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
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
                  stream: _messageManager.conversationStream,
                  builder: (context, snapshot) {
                    final _conversations = snapshot.data ?? [];

                    final _coreConversations = _conversations.reversed.map((c) {
                      return Conversations(
                        id: c.id,
                        time: c.time.toString(),
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
                                if (_messageManager.responseState ==
                                    ResponseState.loading)
                                  ProcessingAnimation(),
                              ],
                            ),
                    );
                  }),
              // ProcessingAnimation(),
              Padding(
                padding: EdgeInsets.only(bottom: bottomInset + 10),
                child: ChatInputBar(
                  sendMessage: (it) => _messageManager.sendMessage(it),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: AppDrawer(
        onClearChat: _messageManager.clearChat,
      ),
    );
  }
}

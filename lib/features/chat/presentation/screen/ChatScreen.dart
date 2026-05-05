import 'dart:io';

import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/chat/data/repository/messageManager.dart';
import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:aida/features/chat/presentation/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/widget/ChatInputBar.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:aida/features/chat/presentation/widget/Conversations.dart';
import 'package:aida/features/chat/presentation/widget/processingAnimation.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
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
  final MessageManager _messageManager = MessageManager(MessageRepository());
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _messageManager.loadConversations();
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
                  title: Text('Confirm Exit',
                      style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                  content: Text('Are you sure you want to exit the chat?',
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: textColor)),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () =>
                          Navigator.of(context).pop(false), // Return FALSE
                    ),
                    TextButton(
                      child: Text('Exit', style: TextStyle(color: Colors.red)),
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Return TRUE
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
      drawer: Drawer(
        backgroundColor:
            Theme.of(context).extension<CustomColors>()!.lightCardColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header (optional)
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Text(
                'AIDA',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontFamily: 'Baloo2Bold',
                ),
              ),
            ),
            // Drawer items
            ListTile(
              // leading: Icon(Icons.open_in_new_rounded, color: textColor),
              title: Text(
                'Works',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'QuicksandMedium',
                ),
              ),
              onTap: () {
                // Handle tap on the Home item
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: BaseLine(
                width: 1,
                dividerHeight: 0.5,
                colour: textColor.withOpacity(0.2),
              ),
            ),
            // Drawer items
            ListTile(
              // leading: Icon(Icons.open_in_new_rounded, color: textColor),
              title: Text(
                'Guide me',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'QuicksandMedium',
                ),
              ),
              onTap: () {
                if (mounted) context.go('/welcome');
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: BaseLine(
                width: 1,
                dividerHeight: 0.5,
                colour: textColor.withOpacity(0.2),
              ),
            ),
            ListTile(
              // leading: Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Clear Chat',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontFamily: 'QuicksandMedium',
                ),
              ),
              onTap: () {
                _showConfirmationDialog(
                  context,
                  () async {
                    await _messageManager.clearChat();
                  },
                );
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, void Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(
          //   'Confirm',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontFamily: 'Baloo2SemiBold'),
          // ),
          content: Text(
            'Are you sure you want to clear the chats?',
            style: TextStyle(
                fontFamily: 'QuicksandRegular',
                color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'QuicksandMedium'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Clear',
                style:
                    TextStyle(color: Colors.red, fontFamily: 'QuicksandMedium'),
              ),
              onPressed: () {
                // Perform the action to clear the chats
                onPressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

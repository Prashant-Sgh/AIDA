import 'dart:io';
import 'package:flutter/widget_previews.dart';
import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/chat/data/repository/messageManager.dart';

import 'package:aida/features/chat/data/repository/messageRepository.dart';
import 'package:aida/features/chat/presentation/widget/ChatHint.dart';
import 'package:aida/features/chat/presentation/widget/ChatScrAppBar.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final textColor = Theme.of(context).colorScheme.onSurface;
    bool _isExiting = false; // Flag to track if the user is trying to exit
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_isExiting) {
            return false; // Deny the pop to happen, since it is already in the process of exiting.
          } else {
            // Display an alert dialog to confirm exit
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Confirm Exit',
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to exit the chat?',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Exit',
                        style: GoogleFonts.quicksand(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isExiting =
                              true; // Set the flag to true to indicate that the user is trying to exit
                        });
                        exit(0); // Exit the app immediately
                      },
                    ),
                  ],
                );
              },
            );
          }
          // Handle back button press if needed
          return true; // Allow the pop to happen
        },
        child: Scaffold(
          appBar: ChatScrAppBar(),
          body: StreamBuilder<List<types.Message>>(
            stream: messageManager.conversationStream,
            builder: (context, snapshot) {
              final uiMessages = snapshot.data ?? [];

              if (uiMessages.isEmpty) {
                return Center(
                  child: ChatHint(),
                );
              }

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
                      color: const Color(0xFF7E211A),
                      fontSize: 15,
                      fontFamily: 'QuicksandMedium',
                    ),
                  ),
                  onTap: () {
                    _showConfirmationDialog(
                      context,
                      () async {
                        await messageManager.clearChat();
                      },
                    );
                  },
                ),
                // Add more items as needed
              ],
            ),
          ),
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

import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_fonts/google_fonts.dart';

class Conversations extends StatelessWidget {
  final MessageObj messageObj;

  const Conversations({
    super.key,
    required this.messageObj,
  });

  bool get isUser => messageObj.role == 'user';

  @override
  Widget build(BuildContext context) {
    // final Color textColor = Colors.white;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color backgroundColor = isUser
        ? Colors.purpleAccent.withAlpha(50)
        : Colors.purple.withAlpha(20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                    color: Colors.white.withAlpha(
                      20,
                    ),
                    width: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: (isUser) ? Radius.circular(10.0) : Radius.zero,
                  topRight: (isUser) ? Radius.zero : Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Text(
                messageObj.content,
                style: TextStyle(color: textColor, fontSize: 13.0),
              ),
            ),

            SizedBox(height: 4.0), // Space between message and timestamp
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                // '01:00 am',
                messageObj.createdAt.toString(),
                style: GoogleFonts.quicksand(
                    color: textColor,
                    fontSize: 8.0,
                    fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

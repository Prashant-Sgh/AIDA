import 'package:aida/features/chat/data/model/message.dart';
import 'package:flutter/material.dart';
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
    // final Color textColor = Theme.of(context).colorScheme.onSurface;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = Color(0xFFfafaff);
    final Color timeTextColor =
        isDarkMode ? Color(0xFFe4d9ff) : Color(0xFF000000);
    final Color backgroundColor = isUser
        // ? Color(0xFFc095e4)
        // : Color(0xFFcac7ff);

        // ? Color(0xFF3c6e71)
        // : Color(0xFF284b63);

        // Choice - 1
        // ? Color(0xFF124559)
        // : Color(0xFF598392);

        // Choice - 2
        ? Color(0xFF1e2749)
        : Color(0xFF273469);

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
                  topLeft: (isUser) ? Radius.circular(20.0) : Radius.zero,
                  topRight: (isUser) ? Radius.zero : Radius.circular(30.0),
                  bottomLeft:
                      (isUser) ? Radius.circular(15.0) : Radius.circular(20.0),
                  bottomRight:
                      (isUser) ? Radius.circular(20.0) : Radius.circular(30.0),
                ),
              ),
              child: Text(
                messageObj.content,
                style: GoogleFonts.quicksand(
                  color: textColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0.4,

                  
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: 4.0), // Space between message and timestamp
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                // '01:00 am',
                messageObj.createdAt.toString(),
                style: GoogleFonts.jetBrainsMono(
                    color: timeTextColor,
                    fontSize: 8.0,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 10.0,
                    letterSpacing: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

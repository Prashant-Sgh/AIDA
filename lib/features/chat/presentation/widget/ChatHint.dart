import 'package:aida/features/chat/data/model/Hints.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHint extends StatelessWidget {
  const ChatHint({super.key});
  static Hints hints = Hints();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hints.title,
              style: GoogleFonts.baloo2(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 0.63,
                letterSpacing: 0.96,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...hints.hintQuestions.asMap().entries.map(
                    (entry) {
                      int index = entry.key + 1;
                      String hint = entry.value;
                      return Text(
                        "$index. $hint",
                        style: GoogleFonts.quicksand(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.43,
                          letterSpacing: 0.56,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

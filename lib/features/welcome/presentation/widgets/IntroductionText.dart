import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:aida/features/welcome/presentation/widgets/MascotHints.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionText extends StatelessWidget {
  const IntroductionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'AIDA',
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 0.63,
            letterSpacing: 0.96,
          ),
        ),
        SizedBox(height: 28),
        SizedBox(
          width: 335,
          child: Text(
            'AIDA is an AI cross-platform app, build using Flutter. to act as an AI chat-bot for Atul’s portfolio, you can use AIDA to know about Atul’s experience, projects done by him so far. Or you can use it like a conversational AI but characterized.',
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.43,
              letterSpacing: 0.56,
            ),
          ),
        ),
        SizedBox(height: 27.51),
        BaseLine(width: 161.03,),
      ],
    );
  }
}

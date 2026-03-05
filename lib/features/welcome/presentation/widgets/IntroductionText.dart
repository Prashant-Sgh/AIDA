import 'package:flutter/material.dart';

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
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontFamily: 'Baloo 2',
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w300,
              height: 1.43,
              letterSpacing: 0.56,
            ),
          ),
        )
      ],
    );
  }
}

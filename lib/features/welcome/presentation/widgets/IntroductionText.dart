import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionText extends StatelessWidget {
  const IntroductionText({super.key});
  final Color bgYellow = const Color.fromARGB(255, 231, 158, 0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = GoogleFonts.quicksand(
      color: colorScheme.onSurface,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      // height: 1.43,
      height: 1.63,
      // letterSpacing: 0.56,
      letterSpacing: 0.66,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What\'s AIDA?',
          style: GoogleFonts.baloo2(
            color: colorScheme.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 0.63,
            letterSpacing: 0.96,
          ),
        ),
        SizedBox(height: 28),
        SizedBox(
          width: 300,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: baseStyle,
              children: [
                // First sentence
                TextSpan(
                  text: 'AIDA',
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    backgroundColor: bgYellow.withOpacity(0.6),
                  ),
                ),
                TextSpan(text: ' is a '),
                TextSpan(
                  text: 'customisable AI chatbot',
                  style: baseStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', developed as a '),
                TextSpan(
                  text: 'cross-platform app (Web, iOS and Android)',
                  style: baseStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    backgroundColor: bgYellow.withOpacity(0.4),
                  ),
                ),
                TextSpan(text: ', build using '),
                TextSpan(
                  text: 'Flutter',
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(text: '. '),
                // Second sentence
                TextSpan(text: 'It acts as a '),
                TextSpan(
                  text: 'personal assistant',
                  style: baseStyle.copyWith(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' to answer general questions on behalf of '),
                TextSpan(
                  text: 'Atul',
                  style: baseStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '. '),
                // Line break
                TextSpan(text: '\n\n'),
                // Third sentence
                TextSpan(text: 'You can '),
                TextSpan(
                  text: 'customize AIDA',
                  style: baseStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to your needs by adding your own '),
                TextSpan(
                  text: 'context',
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    backgroundColor: bgYellow.withValues(alpha: 0.25),
                  ),
                ),
                TextSpan(text: '. '),
                // Fourth sentence
                TextSpan(text: 'Or you can use it like a '),
                TextSpan(
                  text: 'conversational AI',
                  style: baseStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' but characterized.'),
              ],
            ),
          ),
        ),
        SizedBox(height: 27.51),
        BaseLine(
          width: 161.03,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetaText extends StatelessWidget {
  const MetaText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'From:\n',
            // text: 'By: \n',
            style: GoogleFonts.quicksand(
              color: Colors.black.withValues(alpha: 0.60),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.43,
              letterSpacing: 0.56,
            ),
          ),
          TextSpan(
            // text: 'Singhapps.com',
            text: 'Atul Singh',
            style: GoogleFonts.quicksand(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.43,
              letterSpacing: 0.56,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

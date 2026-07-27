import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIDAAnimation extends StatefulWidget {
  const AIDAAnimation({super.key});

  @override
  State<AIDAAnimation> createState() => _AIDAAnimationState();
}

class _AIDAAnimationState extends State<AIDAAnimation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'AIDA',
      style: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w200,
        height: 0.63,
        letterSpacing: 0.96,
      ),
    );
  }
}

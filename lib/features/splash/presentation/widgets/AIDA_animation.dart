import 'package:flutter/material.dart';

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
      style: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w200,
        height: 0.63,
        letterSpacing: 0.96,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AIDAAnimation extends StatefulWidget {
  const AIDAAnimation({super.key});

  @override
  State<AIDAAnimation> createState() => _AIDAAnimationState();
}

class _AIDAAnimationState extends State<AIDAAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text(
    //   'AIDA',
    //   style: TextStyle(
    //     color: Colors.black,
    //     fontSize: 32,
    //     fontFamily: 'Inter',
    //     fontWeight: FontWeight.w200,
    //     height: 0.63,
    //     letterSpacing: 0.96,
    //   ),
    // );
    return AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(
            'AIDA',
            textStyle: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w200,
        height: 0.63,
        letterSpacing: 0.96,
      ),
            speed: const Duration(milliseconds: 2000),
          ),
        ],
        totalRepeatCount: 4,
        pause: const Duration(milliseconds: 1000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
        // controller: myAnimatedTextController
        );
  }
}

import 'package:aida/features/welcome/presentation/widgets/HintBubble.dart';
import 'package:flutter/material.dart';

class MascotHints extends StatelessWidget {
  final List<String> hints;

  const MascotHints({
    super.key,
    required this.hints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(      
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              "assets/mascots/welcome/Mascot-01.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            // top: 0,
            right: 0,
            bottom: 171.1,
            child: HintBubble(text: hints[0]),
          ),
        ],
      ),],);
  }
}

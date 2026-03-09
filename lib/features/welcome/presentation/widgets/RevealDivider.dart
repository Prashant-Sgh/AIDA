import 'package:flutter/material.dart';

class RevealDivider extends StatelessWidget {
  const RevealDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353,
      height: 18,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: const Color(0xFFDAEDFF),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

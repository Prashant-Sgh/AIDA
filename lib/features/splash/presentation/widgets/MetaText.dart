import 'package:flutter/material.dart';

class MetaText extends StatelessWidget {
  const MetaText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'From\n',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.60),
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w300,
              height: 1.43,
              letterSpacing: 0.56,
            ),
          ),
          TextSpan(
            text: 'Atul Singh',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 14,
              fontFamily: 'Quicksand',
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

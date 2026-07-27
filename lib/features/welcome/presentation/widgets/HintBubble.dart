import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HintBubble extends StatelessWidget {
  final String text;

  const HintBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Tail
        Positioned(
          bottom: -12.5,
          left: -2,
          child: Transform.rotate(
            angle: 1.57, // radians (≈ 90°)
            child: CustomPaint(
              size: const Size(38, 63),
              painter: _TrianglePainter(context),
            ),
          ),
        ),

        /// Bubble
        ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 154,
            ),
            child: Container(
              // margin: const EdgeInsets.only(left: 14),
              padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                text,
                textAlign: TextAlign.left,
                softWrap: true,
                style: GoogleFonts.quicksand(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.54,
                  letterSpacing: 0.39,
                ),
              ),
            )),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final BuildContext context;

  _TrianglePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.secondary
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

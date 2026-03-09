import 'package:flutter/widgets.dart';

class BaseLine extends StatelessWidget {
  final double width;
  final double dividerHeight;
  final Color colour;
  const BaseLine({super.key, required this.width, this.dividerHeight = 0.5, this.colour = const Color(0x99B3B3B3)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: dividerHeight,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: colour,
          ),
        ),
      ),
    );
  }
}

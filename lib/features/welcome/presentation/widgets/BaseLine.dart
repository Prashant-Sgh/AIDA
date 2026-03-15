import 'package:aida/core/theme/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseLine extends StatelessWidget {
  final double width;
  final double dividerHeight;
  final Color? colour;
  const BaseLine(
      {super.key, required this.width, this.dividerHeight = 0.5, this.colour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: dividerHeight,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: colour ??
                Theme.of(context).extension<CustomColors>()!.lineColor,
          ),
        ),
      ),
    );
  }
}

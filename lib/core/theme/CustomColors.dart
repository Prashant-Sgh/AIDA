import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color lineColor;
  final Color dropDownLineColor;

  const CustomColors({
    required this.lineColor,
    required this.dropDownLineColor,
  });

  @override
  CustomColors copyWith({Color? lineColor, Color? dropDownLineColor}) {
    return CustomColors(
      lineColor: lineColor ?? this.lineColor,
      dropDownLineColor: dropDownLineColor ?? this.dropDownLineColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
      dropDownLineColor: Color.lerp(dropDownLineColor, other.dropDownLineColor, t)!,
    );
  }
}
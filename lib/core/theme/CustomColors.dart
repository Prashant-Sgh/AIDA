import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color lineColor;
  final Color dropDownLineColor;
  final Color lightCardColor;

  const CustomColors({
    required this.lineColor,
    required this.dropDownLineColor,
    required this.lightCardColor,
  });

  @override
  CustomColors copyWith({Color? lineColor, Color? dropDownLineColor, Color? lightCardColor}) {
    return CustomColors(
      lineColor: lineColor ?? this.lineColor,
      dropDownLineColor: dropDownLineColor ?? this.dropDownLineColor,
      lightCardColor: lightCardColor ?? this.lightCardColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
      dropDownLineColor: Color.lerp(dropDownLineColor, other.dropDownLineColor, t)!,
      lightCardColor: Color.lerp(lightCardColor, other.lightCardColor, t)!,
    );
  }
}
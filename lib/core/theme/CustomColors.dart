import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color lineColor;
  final Color dropDownLineColor;
  final Color lightCardColor;
  final Color contextScrBackground;
  final Color contextScrCard;
  final Color contextScrCardStroke;
  final Color contextScrExpandedCard;
  final Color contextScrExpandedCardTxtField;
  final Color contextScrButtonClearTxt;

  const CustomColors({
    required this.lineColor,
    required this.dropDownLineColor,
    required this.lightCardColor,
    required this.contextScrBackground,
    required this.contextScrCard,
    required this.contextScrCardStroke,
    required this.contextScrExpandedCard,
    required this.contextScrExpandedCardTxtField,
    required this.contextScrButtonClearTxt,
  });

  @override
  CustomColors copyWith(
      {Color? lineColor,
      Color? dropDownLineColor,
      Color? lightCardColor,
      Color? contextScrBackground,
      Color? contextScrCard,
      Color? contextScrCardStroke,
      Color? contextScrExpandedCard,
      Color? contextScrExpandedCardTxtField,
      Color? contextScrButtonTxt}) {
    return CustomColors(
      lineColor: lineColor ?? this.lineColor,
      dropDownLineColor: dropDownLineColor ?? this.dropDownLineColor,
      lightCardColor: lightCardColor ?? this.lightCardColor,
      contextScrBackground: contextScrBackground ?? this.contextScrBackground,
      contextScrCard: contextScrCard ?? this.contextScrCard,
      contextScrCardStroke: contextScrCardStroke ?? this.contextScrCardStroke,
      contextScrExpandedCard:
          contextScrExpandedCard ?? this.contextScrExpandedCard,
      contextScrExpandedCardTxtField:
          contextScrExpandedCardTxtField ?? this.contextScrExpandedCardTxtField,
      contextScrButtonClearTxt:
          contextScrButtonClearTxt ?? this.contextScrButtonClearTxt,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
      dropDownLineColor:
          Color.lerp(dropDownLineColor, other.dropDownLineColor, t)!,
      lightCardColor: Color.lerp(lightCardColor, other.lightCardColor, t)!,
      contextScrBackground:
          Color.lerp(contextScrBackground, other.contextScrBackground, t)!,
      contextScrCard: Color.lerp(contextScrCard, other.contextScrCard, t)!,
      contextScrCardStroke:
          Color.lerp(contextScrCardStroke, other.contextScrCardStroke, t)!,
      contextScrExpandedCard:
          Color.lerp(contextScrExpandedCard, other.contextScrExpandedCard, t)!,
      contextScrExpandedCardTxtField: Color.lerp(contextScrExpandedCardTxtField,
          other.contextScrExpandedCardTxtField, t)!,
      contextScrButtonClearTxt: Color.lerp(
          contextScrButtonClearTxt, other.contextScrButtonClearTxt, t)!,
    );
  }
}

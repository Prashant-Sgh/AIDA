import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

TextSpan formatMessage({
  required String message,
  required Color textColor,
  double fontSize = 12.5,
  FontWeight fontWeight = FontWeight.w200,
  double letterSpacing = 0.4,
  double height = 1.5,
}) {
  final baseStyle = GoogleFonts.quicksand(
    color: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );

  final boldStyle = baseStyle.copyWith(
    fontWeight: FontWeight.w600,
  );

  final italicStyle = baseStyle.copyWith(
    fontStyle: FontStyle.italic,
  );

  final linkStyle = baseStyle.copyWith(
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
  );

  final children = <InlineSpan>[];

  final regex = RegExp(
    r'\*\*(.*?)\*\*|'          // **bold**
    r'\*(.*?)\*|'              // *italic*
    r'\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)', // [text](url)
    dotAll: true,
  );

  int lastIndex = 0;

  for (final match in regex.allMatches(message)) {
    // Normal text before match
    if (match.start > lastIndex) {
      children.add(
        TextSpan(
          text: message.substring(lastIndex, match.start),
          style: baseStyle,
        ),
      );
    }

    // **Bold**
    if (match.group(1) != null) {
      children.add(
        TextSpan(
          text: match.group(1),
          style: boldStyle,
        ),
      );
    }

    // *Italic*
    else if (match.group(2) != null) {
      children.add(
        TextSpan(
          text: match.group(2),
          style: italicStyle,
        ),
      );
    }

    // [text](url)
    else if (match.group(3) != null && match.group(4) != null) {
      final label = match.group(3)!;
      final url = match.group(4)!;

      children.add(
        TextSpan(
          text: label,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Handle URL here
              debugPrint('Open: $url');
            },
        ),
      );
    }

    lastIndex = match.end;
  }

  // Remaining text
  if (lastIndex < message.length) {
    children.add(
      TextSpan(
        text: message.substring(lastIndex),
        style: baseStyle,
      ),
    );
  }

  return TextSpan(
    style: baseStyle,
    children: children,
  );
}
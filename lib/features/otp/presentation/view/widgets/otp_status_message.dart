import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpStatusMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const OtpStatusMessage({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor =
        isError ? Colors.red.withOpacity(0.12) : Colors.green.withOpacity(0.12);

    final borderColor =
        isError ? Colors.red.withOpacity(0.24) : Colors.green.withOpacity(0.24);

    final iconColor = isError ? Colors.redAccent : Colors.green;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.cancel_rounded : Icons.check_circle_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class OtpActionsWidget extends StatelessWidget {
  final int remainingSeconds;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  const OtpActionsWidget({
    super.key,
    required this.remainingSeconds,
    required this.onResend,
    required this.onChangeEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final bool canResend = remainingSeconds == 0;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: canResend ? onResend : null,
          child: Text(
            canResend
                ? "Resend OTP"
                : "Resend in 00:${remainingSeconds.toString().padLeft(2, '0')}",
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        TextButton(
          onPressed: onChangeEmail,
          child: Text(
            "Change Email",
            style: GoogleFonts.quicksand(
              color: colorScheme.onSurface
                  .withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

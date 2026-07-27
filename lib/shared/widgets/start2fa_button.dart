import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Start2FAButton extends ConsumerWidget {
  const Start2FAButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>();

    /// Colors
    final backgroundColor = customColors?.lightCardColor ?? colorScheme.surface;

    final textColor = colorScheme.onSurface;

    const Color accentColor = Color(0xFFFFB84D);

    final contextWrapper = context;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await ref.read(authenticationViewModelProvider.notifier).reSendOtp();
          if (contextWrapper.mounted) contextWrapper.push('/otp');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.22),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 17,
                color: backgroundColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Start 2FA',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: backgroundColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

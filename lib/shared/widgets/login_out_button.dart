import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOutButton extends ConsumerWidget {
  final bool isLoginButton;

  const LoginOutButton({
    super.key,
    required this.isLoginButton,
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

    return GestureDetector(
      onTap: () async {
        if (isLoginButton) {
          context.push('/authentication');
        } else {
          await ref
              .read(authenticationViewModelProvider.notifier)
              .logoutAdmin();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: textColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLoginButton ? Icons.login_rounded : Icons.logout_rounded,
              size: 16,
              color: backgroundColor,
            ),
            const SizedBox(width: 8),
            Text(
              isLoginButton ? 'Log in' : 'Log out',
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
    );
  }
}

import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticateButtonWidget extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final bool enable;

  const AuthenticateButtonWidget({
    super.key,
    required this.onPressed,
    required this.enable,
  });

  @override
  ConsumerState<AuthenticateButtonWidget> createState() =>
      _AuthenticateButtonWidgetState();
}

class _AuthenticateButtonWidgetState
    extends ConsumerState<AuthenticateButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isLoading =
        ref.watch(authenticationViewModelProvider).isLoading;

    final primaryColor = colorScheme.primary;

    final disabledColor =
        colorScheme.outline.withOpacity(0.15);

    final backgroundColor =
        widget.enable ? primaryColor : disabledColor;

    final textColor = widget.enable
        ? colorScheme.onPrimary
        : colorScheme.onSurface.withOpacity(0.45);

    return GestureDetector(
      onTapDown: (_) {
        if (!widget.enable || isLoading) return;

        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        if (!widget.enable || isLoading) return;

        setState(() {
          _isPressed = false;
        });

        widget.onPressed();
      },
      onTapCancel: () {
        if (!widget.enable || isLoading) return;

        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 58,
        width: double.infinity,
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: widget.enable
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.20),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colorScheme.onPrimary,
                  ),
                )
              : Row(
                  key: const ValueKey('text'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Authenticate',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: textColor,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
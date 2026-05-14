import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const Duration _animationDuration = Duration(milliseconds: 180);
const double _buttonHeight = 56;

class VerifyOtpButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const VerifyOtpButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  State<VerifyOtpButton> createState() =>
      _VerifyOtpButtonState();
}

class _VerifyOtpButtonState
    extends State<VerifyOtpButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() {
            _isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        if (widget.enabled) {
          setState(() {
            _isPressed = false;
          });

          widget.onPressed();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.97 : 1.0),
        width: double.infinity,
        height: _buttonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.enabled
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "Verify",
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: widget.enabled
                ? colorScheme.surface
                : colorScheme.onSurface
                    .withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticateButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool enable;

  const AuthenticateButtonWidget({
    super.key,
    required this.onPressed,
    required this.enable,
  });

  @override
  State<AuthenticateButtonWidget> createState() =>
      _AuthenticateButtonWidgetState();
}

class _AuthenticateButtonWidgetState extends State<AuthenticateButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.enable ? Colors.blueAccent : Colors.grey.shade400;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.enable) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.enable) {
          setState(() => _isPressed = false);
          widget.onPressed();
        }
      },
      onTapCancel: () {
        if (widget.enable) {
          setState(() => _isPressed = false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: widget.enable
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.enable ? 1.0 : 0.7,
          child: Text(
            "Authenticate",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

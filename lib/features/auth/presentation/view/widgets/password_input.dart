import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 Design Tokens
const double _borderRadius = 14;
const double _borderWidth = 1.5;
const double _fontSize = 16;
const Duration _animationDuration = Duration(milliseconds: 200);

final Color _focusedBorderColor = Colors.blueAccent;
final Color _unfocusedBorderColor = Colors.grey.shade300;
final Color _backgroundColor = Colors.white;
final Color _shadowColor = Colors.blueAccent.withOpacity(0.15);

class PasswordInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode focusNode;
  final bool error; // 👈 added

  const PasswordInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.focusNode,
    this.error = false,
  });

  @override
  ConsumerState<PasswordInputWidget> createState() =>
      _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends ConsumerState<PasswordInputWidget> {
  bool isFocused = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      setState(() {
        isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  void toggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showError = widget.error;

    final borderColor = showError
        ? Colors.redAccent
        : isFocused
            ? _focusedBorderColor
            : _unfocusedBorderColor;

    final backgroundColor =
        showError ? Colors.red.withOpacity(0.04) : _backgroundColor;

    final shadowColor = showError ? Colors.red.withOpacity(0.14) : _shadowColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: _animationDuration,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: borderColor,
              width: _borderWidth,
            ),
            boxShadow: (isFocused || showError)
                ? [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: obscurePassword,
            style: GoogleFonts.quicksand(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  showError ? 'Password is incorrect' : 'Enter your password',
              hintStyle: GoogleFonts.quicksand(
                fontSize: _fontSize,
                color: showError ? Colors.redAccent : Colors.grey,
              ),

              /// LEFT ICON
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: showError
                    ? const Icon(
                        Icons.lock_outline_rounded,
                        key: ValueKey('error'),
                        color: Colors.redAccent,
                      )
                    : Icon(
                        obscurePassword
                            ? Icons.lock_rounded
                            : Icons.lock_open_rounded,
                        key: ValueKey(obscurePassword),
                        color: Colors.grey.shade700,
                      ),
              ),

              /// RIGHT ICON
              suffixIcon: IconButton(
                splashRadius: 18,
                onPressed: toggleObscurePassword,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    key: ValueKey(obscurePassword),
                    color: showError ? Colors.redAccent : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),

        /// ERROR MESSAGE
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showError
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 4,
                  ),
                  child: Text(
                    'The password you entered is incorrect',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

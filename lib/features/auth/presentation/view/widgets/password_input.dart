import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design Tokens
const double _borderRadius = 18;
const double _borderWidth = 1.2;
const double _fontSize = 16;
const Duration _animationDuration = Duration(milliseconds: 220);

class PasswordInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode focusNode;
final PasswordValidationState? passwordValidationState;

  const PasswordInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.focusNode,
    this.passwordValidationState = PasswordValidationState.none,
  });

  @override
  ConsumerState<PasswordInputWidget> createState() =>
      _PasswordInputWidgetState();
}

class _PasswordInputWidgetState
    extends ConsumerState<PasswordInputWidget> {
  bool isFocused = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {
          isFocused = widget.focusNode.hasFocus;
        });
      }
    });
  }

  void toggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool showError = widget.passwordValidationState == PasswordValidationState.invalid;

    final focusedColor = colorScheme.primary;
    final unfocusedColor = colorScheme.outline.withOpacity(0.25);
    final errorColor = Colors.redAccent;

    final fillColor = theme.brightness == Brightness.dark
        ? colorScheme.surface
        : Colors.white;

    final borderColor = showError
        ? errorColor
        : isFocused
            ? focusedColor
            : unfocusedColor;

    final backgroundColor =
        showError ? errorColor.withOpacity(0.05) : fillColor;

    final shadowColor = showError
        ? errorColor.withOpacity(0.12)
        : focusedColor.withOpacity(0.10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
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
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            style: GoogleFonts.quicksand(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: showError
                  ? 'Password is incorrect'
                  : 'Password',
              hintStyle: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.45),
              ),

              /// Left Icon
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: showError
                    ? const Icon(
                        Icons.error_outline_rounded,
                        key: ValueKey('error'),
                        color: Colors.redAccent,
                      )
                    : Icon(
                        obscurePassword
                            ? Icons.password_rounded
                            : Icons.password_outlined,
                        key: ValueKey(obscurePassword),
                        color:
                            colorScheme.onSurface.withOpacity(0.55),
                      ),
              ),

              /// Right Icon
              suffixIcon: IconButton(
                splashRadius: 18,
                onPressed: toggleObscurePassword,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    key: ValueKey(obscurePassword),
                    color: showError
                        ? errorColor
                        : colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),

        /// Error Message
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
                      color: errorColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

enum PasswordValidationState {
  valid,
  invalid,
  none,
}
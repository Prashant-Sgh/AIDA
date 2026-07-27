import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design Tokens
const double _borderRadius = 18;
const double _borderWidth = 1.2;
const double _fontSize = 16;
const Duration _animationDuration = Duration(milliseconds: 220);

class EmailInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  // final bool isEmailValid;
  final EmailValidationState emailValidationState;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const EmailInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    // required this.isEmailValid,
    required this.focusNode,
    required this.nextFocusNode,
    this.emailValidationState = EmailValidationState.initial,
  });

  @override
  ConsumerState<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends ConsumerState<EmailInputWidget> {
  bool isFocused = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool showError = widget.emailValidationState == EmailValidationState.invalid;

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
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: GoogleFonts.quicksand(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  showError ? 'Please enter a valid email' : 'Email address',
              hintStyle: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.45),
              ),
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
                    : widget.emailValidationState == EmailValidationState.valid
                        ? const Icon(
                            Icons.check_circle_rounded,
                            key: ValueKey('valid'),
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.email_rounded,
                            key: const ValueKey('default'),
                            color: colorScheme.onSurface.withOpacity(0.55),
                          ),
              ),
            ),
            onChanged: widget.onChanged,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showError
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 4,
                  ),
                  child: Text(
                    'That email doesn\'t look right',
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

enum EmailValidationState { initial, valid, invalid }
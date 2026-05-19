import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 Design Tokens (keep at top)
const double _borderRadius = 14;
const double _borderWidth = 1.5;
const double _fontSize = 16;
const Duration _animationDuration = Duration(milliseconds: 200);

final Color _focusedBorderColor = Colors.blueAccent;
final Color _unfocusedBorderColor = Colors.grey.shade300;
final Color _backgroundColor = Colors.white;
final Color _shadowColor = Colors.blueAccent.withOpacity(0.15);

class EmailInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isEmailValid;
  final bool error; // 👈 added
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const EmailInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.isEmailValid,
    required this.focusNode,
    required this.nextFocusNode,
    this.error = false, // 👈 default false
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
      setState(() {
        isFocused = widget.focusNode.hasFocus;
      });
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

    final shadowColor = showError
        ? Colors.red.withOpacity(0.14)
        : _shadowColor;

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
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.quicksand(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  showError ? 'Please enter a valid email' : 'Enter your email',
              hintStyle: GoogleFonts.quicksand(
                fontSize: _fontSize,
                color: showError ? Colors.redAccent : Colors.grey,
              ),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: showError
                    ? const Icon(
                        Icons.error_outline_rounded,
                        key: ValueKey('error'),
                        color: Colors.redAccent,
                      )
                    : widget.isEmailValid
                        ? const Icon(
                            Icons.mark_email_read_rounded,
                            key: ValueKey('valid'),
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.email_rounded,
                            key: ValueKey('default'),
                          ),
              ),
            ),
            onChanged: widget.onChanged,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.nextFocusNode);
            },
          ),
        ),

        /// Optional error message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showError
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 4,
                  ),
                  child: Text(
                    'That email doesn’t look right',
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
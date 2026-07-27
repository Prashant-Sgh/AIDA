import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const double _otpBoxSize = 64;
const double _otpBorderRadius = 18;
const Duration _animationDuration = Duration(milliseconds: 180);

class OtpDigitField extends StatefulWidget {
  final TextEditingController? previousController;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  const OtpDigitField({
    super.key,
    required this.previousController,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
  });

  @override
  State<OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<OtpDigitField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: _animationDuration,
      width: _otpBoxSize,
      height: _otpBoxSize + 4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(_otpBorderRadius),
        border: Border.all(
          color: _isFocused
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.2),
          width: _isFocused ? 1.8 : 1,
        ),
      ),
      // child: KeyboardListener(
      //   focusNode: widget.focusNode,
      //   onKeyEvent: (event) {
      //     if (event is KeyDownEvent &&
      //         event.logicalKey == LogicalKeyboardKey.backspace) {
      //       // if current field has text -> clear it
      //       if (widget.controller.text.isNotEmpty) {
      //         widget.controller.clear();
      //       }
      //       if (widget.previousFocusNode != null) {
      //         widget.previousFocusNode!.requestFocus();
      //         widget.previousController?.clear();
      //       }
      //     }
      //   },
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.quicksand(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            widget.nextFocusNode?.requestFocus();

            if (widget.nextFocusNode == null) {
              FocusScope.of(context).unfocus();
            }
          } else {
            widget.previousFocusNode?.requestFocus();
          }
        },
      ),
      // ),
    );
  }
}

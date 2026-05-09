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

class PasswordInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode focusNode;

  const PasswordInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.focusNode,
  }) : super(key: key);

  @override
  ConsumerState<PasswordInputWidget> createState() =>
      _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends ConsumerState<PasswordInputWidget> {
  bool isFocused = false;
  bool obsecurePassword = true;

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
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }

  void toggleObsecurePassword() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isFocused ? _focusedBorderColor : _unfocusedBorderColor;

    return AnimatedContainer(
      duration: _animationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: borderColor, width: _borderWidth),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: _shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: obsecurePassword,
        style: GoogleFonts.quicksand(
          fontSize: _fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: GoogleFonts.quicksand(
            fontSize: _fontSize,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          icon: SizedBox(
            height: 24.0,
            width: 24.0,
            child: IconButton(
              iconSize: 24.0,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: obsecurePassword
                  ? const Icon(Icons.lock_rounded)
                  : const Icon(Icons.lock_open_rounded),
              onPressed: () {
                toggleObsecurePassword();
              },
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

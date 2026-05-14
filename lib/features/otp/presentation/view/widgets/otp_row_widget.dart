import 'package:aida/features/otp/presentation/view/widgets/otp_digit_field.dart';
import 'package:flutter/material.dart';

class OtpRowWidget extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpRowWidget({
    super.key,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => OtpDigitField(
          // controllers: index > 0 ? controllers : null,
          controller: controllers[index],
          focusNode: focusNodes[index],
          nextFocusNode: index < 3 ? focusNodes[index + 1] : null,
          previousFocusNode: index > 0 ? focusNodes[index - 1] : null,
          previousController: index > 0 ? controllers[index - 1] : null,
        ),
      ),
    );
  }
}

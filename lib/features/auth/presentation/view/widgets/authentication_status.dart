import 'package:flutter/material.dart';

class AuthenticationStatusWidget extends StatelessWidget {
  final bool? status;

  const AuthenticationStatusWidget({Key? key, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Authentication Status: $status',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
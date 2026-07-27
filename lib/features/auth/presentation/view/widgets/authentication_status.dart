import 'package:flutter/material.dart';

class AuthenticationStatusWidget extends StatelessWidget {
  final bool? status;

  const AuthenticationStatusWidget({super.key, required this.status});

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
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> openProtectedContextRoute({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final authState = ref.watch(authenticationViewModelProvider);

  final firstStepVerified = authState.firebaseIdToken != null;
  final secondStepVerified = authState.jwtToken != null;

  if (!firstStepVerified) {
    context.go('/authentication');
    return;
  }

  if (firstStepVerified && !secondStepVerified) {
    ref.read(authenticationViewModelProvider.notifier).reSendOtp();
    context.go('/otp');
    return;
  }

  if (firstStepVerified && secondStepVerified) {
    context.go('/context');
    return;
  }
}

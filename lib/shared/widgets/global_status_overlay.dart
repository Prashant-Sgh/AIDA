import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/shared/widgets/otp_pending_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GlobalStatusOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalStatusOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authenticationViewModelProvider);
    final currentGoLocation = GoRouterState.of(context).uri.toString();

    // final showOtpBanner = authState.showOtpPendingBanner && currentGoLocation != '/otp' && currentGoLocation != '/authentication';
    final showOtpBanner = authState.showOtpPendingBanner;

    return Stack(
      children: [
        child,
        if (showOtpBanner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: OtpPendingBanner(
                onClose: ref
                    .read(authenticationViewModelProvider.notifier)
                    .dismissOtpPendingBanner,
                onVerify: () {
                  context.push('/otp');
                },
              ),
            ),
          ),
      ],
    );
  }
}

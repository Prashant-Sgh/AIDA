import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/otp/presentation/view/custom_banners/custom_otp_banner.dart';
import 'package:aida/shared/widgets/otp_pending_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GlobalStatusOverlay extends ConsumerWidget {
  final String? currentLocation;
  final Widget child;

  const GlobalStatusOverlay({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authenticationViewModelProvider);

    // final showOtpBanner = authState.showOtpPendingBanner && currentGoLocation != '/otp' && currentGoLocation != '/authentication';
    final showOtpBanner = authState.showOtpPendingBanner;

    debugPrint('GlobalStatusOverlay CustomBannerType: ${authState.showOtpBannerType}, ${authState.otpBannerType}');

    return Scaffold(
      body: Stack(
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
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: AnimatedSlide(
              // duration: const Duration(milliseconds: 320),
              duration: const Duration(milliseconds: 5000),
              // curve: Curves.easeOutCubic,
              curve: Curves.elasticInOut,
              offset: authState.showOtpBannerType
                  ? Offset.zero
                  : const Offset(0, -1.4),
              child: AnimatedOpacity(
                // duration: const Duration(milliseconds: 220),
                duration: const Duration(milliseconds: 4000),
                opacity: authState.showOtpBannerType ? 1 : 0,
                child: CustomOtpBanner(
                  bannerType: authState.otpBannerType ??
                      BannerType.successfullyVerified,
                  onClose: () {
                    ref
                        .read(authenticationViewModelProvider.notifier)
                        .closeOtpBannerType();
                  },
                ),
              ),
            ),
          ),
        //   Positioned.fill(
        //       child: Column(
                
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //         CustomOtpBanner(
        //           bannerType: BannerType.wrongOtp,
        //           onClose: () {},
        //         ),
        //         CustomOtpBanner(
        //           bannerType: BannerType.otpExpired,
        //           onClose: () {},
        //         ),
        //         CustomOtpBanner(
        //           bannerType: BannerType.tooManyAttempts,
        //           onClose: () {},
        //         ),
        //         CustomOtpBanner(
        //           bannerType: BannerType.successfullyVerified,
        //           onClose: () {},
        //         ),
        //       ]))
       
        ],
      ),
    );
  }
}

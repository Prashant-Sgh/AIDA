import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/otp/presentation/view/custom_banners/custom_otp_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TempScreen extends ConsumerStatefulWidget {
  const TempScreen({super.key});

  @override
  ConsumerState<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends ConsumerState<TempScreen> {
  late String jwtToken;
  // bool showBanner = false;

  Future<void> showBannerNow() async {
    debugPrint('Show banner now');
    await ref
        .read(authenticationViewModelProvider.notifier)
        .setOtpBannerType(BannerType.successfullyVerified);
    debugPrint('Hide banner now');
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.push('/context');
    }
    // showBannerNow();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final backgroundColor = theme.colorScheme.surface;

    debugPrint('Building temp screen');
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomOtpBanner(
              bannerType: BannerType.tooManyAttempts, onClose: () {}),
          const SizedBox(height: 20),
          CustomOtpBanner(
              bannerType: BannerType.successfullyVerified, onClose: () {}),
          const SizedBox(height: 20),
          CustomOtpBanner(bannerType: BannerType.otpExpired, onClose: () {}),
          const SizedBox(height: 20),
          CustomOtpBanner(bannerType: BannerType.wrongOtp, onClose: () {}),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

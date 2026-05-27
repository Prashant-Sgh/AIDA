import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/otp/presentation/view/custom_banners/custom_otp_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TempScreen extends ConsumerStatefulWidget {
  const TempScreen({super.key});

  @override
  ConsumerState<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends ConsumerState<TempScreen> {
  late String jwtToken;

  @override
  void initState() {
    super.initState();
    jwtToken = ref.read(authenticationViewModelProvider).jwtToken ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surface;

    final spaceBtBanners = 20.0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomOtpBanner(bannerType: BannerType.wrongOtp),
              SizedBox(height: spaceBtBanners),
              CustomOtpBanner(bannerType: BannerType.tooManyAttempts),
              SizedBox(height: spaceBtBanners),
              CustomOtpBanner(bannerType: BannerType.otpExpired),
              SizedBox(height: spaceBtBanners),
              CustomOtpBanner(bannerType: BannerType.successfullyVerified),
            ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BannerType {
  successfullyVerified,
  wrongOtp,
  otpExpired,
  tooManyAttempts,
}

class CustomOtpBanner extends StatelessWidget {
  final BannerType bannerType;
  final VoidCallback? onClose;

  const CustomOtpBanner({
    super.key,
    required this.bannerType,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    String bannerTitle;
    String bannerText;
    Color bannerColor;
    Color bannerIconColor;
    Color bannerAccentColor;
    String bannerImage;
    String bannerIcon;

    switch (bannerType) {
      case BannerType.wrongOtp:
        bannerTitle = 'The OTP dosn\'t match';
        bannerText = 'Please enter the correct 6-digit code\nwe sent to you.';
        bannerColor = Color(0xfffdf3ec);
        bannerIconColor = const Color(0xFFf96f5a);
        bannerAccentColor = const Color(0xFFfdcabd);
        bannerImage = 'assets/mascots/otp/successfully_verified.png';
        break;
      case BannerType.otpExpired:
        bannerTitle = 'The OTP has expired';
        bannerText = 'Please request a new code and try again.';
        bannerColor = Color(0xFFfef8ea);
        bannerIconColor = const Color(0xFFfeb424);
        bannerAccentColor = const Color(0xFFfee7ac);
        bannerImage = 'assets/mascots/otp/otp_expired.png';
        break;
      case BannerType.tooManyAttempts:
        bannerTitle = 'Too many attempts';
        bannerText = 'For your security, please try again\nin a few minutes.';
        bannerColor = Color(0xFFefe8f9);
        bannerIconColor = const Color(0xFF6e4cc4);
        bannerAccentColor = const Color(0xFFc3adeb);
        bannerImage = 'assets/mascots/otp/too_many_attempts.png';
        break;
      case BannerType.successfullyVerified:
        bannerTitle = 'Successfully verified!';
        bannerText = 'Your OTP has been verified.\nYou\'re all set.';
        bannerColor = const Color(0xFFeaf6e5);
        bannerIconColor = const Color(0xFF55b340);
        bannerAccentColor = const Color(0xFFb6e0a8);
        bannerImage = 'assets/mascots/otp/successfully_verified.png';
        break;
    }

    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bannerColor,
                border:
                    Border.all(color: bannerIconColor.withAlpha(100), width: 1),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 165),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bannerTitle,
                              style: GoogleFonts.baloo2(
                                color: textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              bannerText,
                              style: GoogleFonts.baloo2(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              color: bannerAccentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.lock_outline_rounded,
                                color: bannerIconColor, size: 24.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50.0)
                ],
              ),
            ),
          ),
          Positioned(
            right: 15.0,
            top: 35.0,
            child: GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close, color: bannerIconColor, size: 20.0),
            ),
          ),
          Positioned(
            left: -10.0,
            bottom: -10.0,
            child: SizedBox(
              height: 120.0,
              child: Image.asset(
                bannerImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

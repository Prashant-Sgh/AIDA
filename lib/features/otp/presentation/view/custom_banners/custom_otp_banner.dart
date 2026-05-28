import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum BannerType {
  successfullyVerified,
  wrongOtp,
  otpExpired,
  tooManyAttempts,
}

class CustomOtpBanner extends StatelessWidget {
  final BannerType bannerType;
  final VoidCallback onClose;

  const CustomOtpBanner({
    super.key,
    required this.bannerType,
    required this.onClose,
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
    IconData bannerIcon;

    switch (bannerType) {
      case BannerType.wrongOtp:
        bannerTitle = 'The OTP doesn\'t match';
        bannerText =
            'Please enter the correct 6-digit\ncode we sent to you.';
        bannerColor = const Color(0xfffdf3ec);
        bannerIconColor = const Color(0xFFf96f5a);
        bannerAccentColor = const Color(0xFFfdcabd);
        bannerIcon = Symbols.close_rounded;
        bannerImage = 'assets/mascots/otp/wrong_otp.png';
        break;

      case BannerType.otpExpired:
        bannerTitle = 'The OTP has expired';
        bannerText =
            'Please request a new code and\ntry again.';
        bannerColor = const Color(0xFFfef8ea);
        bannerIconColor = const Color(0xFFfeb424);
        bannerAccentColor = const Color(0xFFfee7ac);
        bannerIcon = Symbols.access_time_rounded;
        bannerImage = 'assets/mascots/otp/otp_expired.png';
        break;

      case BannerType.tooManyAttempts:
        bannerTitle = 'Too many attempts';
        bannerText =
            'For your security, please try\nagain in a few minutes.';
        bannerColor = const Color(0xFFefe8f9);
        bannerIconColor = const Color(0xFF6e4cc4);
        bannerAccentColor = const Color(0xFFc3adeb);
        bannerIcon = Symbols.lock_outline_rounded;
        bannerImage = 'assets/mascots/otp/too_many_attempts.png';
        break;

      case BannerType.successfullyVerified:
        bannerTitle = 'Successfully verified!';
        bannerText =
            'Your OTP has been verified.\nYou\'re all set.';
        bannerColor = const Color(0xFFeaf6e5);
        bannerIconColor = const Color(0xFF55b340);
        bannerAccentColor = const Color(0xFFb6e0a8);
        bannerIcon = Symbols.check_rounded;
        bannerImage =
            'assets/mascots/otp/successfully_verified.png';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {

              /// RESPONSIVE BREAKPOINT
              final isCompact = constraints.maxWidth < 420;

              /// RESPONSIVE SIZES
              final bannerHeight = isCompact ? 108.0 : 120.0;

              final cardHeight = isCompact ? 92.0 : 100.0;

              final mascotSpace =
                  isCompact ? 118.0 : 165.0;

              final mascotHeight =
                  isCompact ? 100.0 : 120.0;

              final mascotWidth =
                  isCompact ? 120.0 : 150.0;

              final titleFont =
                  isCompact ? 15.0 : 16.0;

              final textFont =
                  isCompact ? 11.0 : 12.0;

              final closeButtonTop =
                  bannerType == BannerType.tooManyAttempts
                      ? (isCompact ? 24.0 : 31.0)
                      : (isCompact ? 28.0 : 35.0);

              final cardBottom =
                  bannerType == BannerType.tooManyAttempts
                      ? 4.0
                      : 0.0;

              return SizedBox(
                height: bannerHeight,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [

                    /// CARD
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: cardBottom,
                      child: Container(
                        height: cardHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: bannerColor,
                          border: Border.all(
                            color: bannerIconColor.withOpacity(0.35),
                            width: 1,
                          ),
                          borderRadius:
                              BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: bannerIconColor
                                  .withOpacity(0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        /// CONTENT
                        child: Row(
                          children: [

                            /// RESERVED SPACE FOR MASCOT
                            SizedBox(width: mascotSpace),

                            /// TEXT + STATUS ICON
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(
                                  right: 50,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                  children: [

                                    /// TEXT
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            bannerTitle,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                GoogleFonts
                                                    .baloo2(
                                              color:
                                                  textColor,
                                              fontSize:
                                                  titleFont,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),

                                          const SizedBox(
                                              height: 2),

                                          Text(
                                            bannerText,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                GoogleFonts
                                                    .baloo2(
                                              fontSize:
                                                  textFont,
                                              fontWeight:
                                                  FontWeight
                                                      .w400,
                                              height: 1.25,
                                              color:
                                                  textColor
                                                      .withOpacity(
                                                          0.72),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    /// STATUS ICON
                                    Container(
                                      decoration:
                                          BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    24),
                                        color:
                                            bannerAccentColor,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets
                                                .all(6.0),
                                        child: Icon(
                                          bannerIcon,
                                          weight: 700,
                                          size: isCompact
                                              ? 22
                                              : 24,
                                          color:
                                              bannerIconColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// CLOSE BUTTON
                    Positioned(
                      right: 14,
                      top: closeButtonTop,
                      child: GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding:
                              const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bannerIconColor
                                .withOpacity(0.10),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: bannerIconColor,
                            size: isCompact ? 18 : 20,
                          ),
                        ),
                      ),
                    ),

                    /// MASCOT
                    Positioned(
                      left: 8,
                      bottom: 0,
                      child:
                          bannerType ==
                                  BannerType
                                      .tooManyAttempts
                              ? SizedBox(
                                  width: mascotWidth,
                                  child: Image.asset(
                                    bannerImage,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )
                              : SizedBox(
                                  height: mascotHeight,
                                  child: Image.asset(
                                    bannerImage,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
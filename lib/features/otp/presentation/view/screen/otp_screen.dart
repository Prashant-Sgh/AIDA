import 'dart:async';
import 'dart:ui';

import 'package:aida/core/theme/theme_provider.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/otp/presentation/view/widgets/otp_action_widget.dart';
import 'package:aida/features/otp/presentation/view/widgets/otp_row_widget.dart';
import 'package:aida/features/otp/presentation/view/widgets/verify_otp_button.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const double _horizontalPadding = 24;
const Duration _animationDuration = Duration(milliseconds: 180);

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      4,
      (_) => TextEditingController(),
    );

    _focusNodes = List.generate(
      4,
      (_) => FocusNode(),
    );

    _startTimer();

    ref.listenManual<AuthenticationState>(authenticationViewModelProvider,
        (previous, next) {
      if (next.isOtpVerified) {
        ref
            .read(authenticationViewModelProvider.notifier)
            .resetOtpVerificationStatus();
        debugPrint("OTP VERIFIED SUCCESSFULLY navigating to context screen");
        context.go('/context');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  /// =======================================================
  /// ⏱ TIMER
  /// =======================================================

  void _startTimer() {
    _remainingSeconds = 60;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  /// =======================================================
  /// 🔢 OTP VALUE
  /// =======================================================

  bool get isOtpFilled {
    return _controllers.every(
      (controller) => controller.text.isNotEmpty,
    );
  }

  String get otp {
    return _controllers.map((controller) => controller.text).join();
  }

  /// =======================================================
  /// 🔐 VERIFY
  /// =======================================================

  void _verifyOtp() {
    FocusScope.of(context).unfocus();

    debugPrint("OTP: $otp");

    ref.read(authenticationViewModelProvider.notifier).verifyOtp(otp);

    /// TODO:
    /// verify otp
  }

  /// =======================================================
  /// 🔁 RESEND OTP
  /// =======================================================

  void _resendOtp() {
    _startTimer();

    /// TODO:
    /// resend otp api
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authenticationViewModelProvider).email;
    final state = ref.watch(authenticationViewModelProvider);
    final loading = state.isLoading;
    final isOtpVerified = state.isOtpVerified;
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,

      /// ===================================================
      /// BODY
      /// ===================================================
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              child: Column(
                children: [
                  /// ============================================
                  /// CONTENT
                  /// ============================================

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          /// BACK BUTTON

                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 40),

                          /// TITLE

                          Text(
                            "Verify OTP",
                            style: GoogleFonts.baloo2(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// SUBTITLE

                          Text(
                            "We sent a 4-digit verification code to",
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            email,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),

                          const SizedBox(height: 48),

                          /// OTP ROW

                          OtpRowWidget(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                          ),

                          const SizedBox(height: 28),

                          /// ACTIONS

                          OtpActionsWidget(
                            remainingSeconds: _remainingSeconds,
                            onResend: _resendOtp,
                            onChangeEmail: () {
                              context.go('/authentication');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ============================================
                  /// VERIFY BUTTON
                  /// ============================================

                  AnimatedPadding(
                    duration: _animationDuration,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: VerifyOtpButton(
                      enabled: isOtpFilled,
                      onPressed: _verifyOtp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

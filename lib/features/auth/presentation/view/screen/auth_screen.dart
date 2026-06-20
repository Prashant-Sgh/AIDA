import 'dart:ui';

import 'package:aida/features/auth/presentation/view/widgets/authenticate_button.dart';
import 'package:aida/features/auth/presentation/view/widgets/email_input.dart';
import 'package:aida/features/auth/presentation/view/widgets/password_input.dart';
import 'package:aida/features/auth/presentation/view/widgets/reset_password_dialog_widget.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool _newUser = false;

  Future<void> _onAuthenticate() async {
    if (!_newUser) {
      await ref.read(authenticationViewModelProvider.notifier).loginAdmin();
      final state = ref.read(authenticationViewModelProvider);

      if (state.firebaseIdToken != null) {
        if (mounted) context.push('/otp');
        // if (mounted) context.go('/context');
      }
    } else {
      // TODO:
      // Sign-up user
      await ref.read(authenticationViewModelProvider.notifier).signUp();
    }
  }

  Future<void> _onGoogleAuthenticate() async {
    debugPrint('onGoogleAuthenticate called');
    await ref
        .read(authenticationViewModelProvider.notifier)
        .continueWithGoogle();

    final state = ref.read(authenticationViewModelProvider);

    if (state.firebaseIdToken != null) {
      if (mounted) context.push('/otp');
    }
  }

  Future<void> _resetPassword() async {
    showDialog(
      context: context,
      builder: (_) => ResetPasswordDialog(
        email: ref.watch(authenticationViewModelProvider).email,
        onConfirm: () async {
          // await ref
          //     .read(authenticationViewModelProvider.notifier)
          //     .resetPassword();
        },
      ),
    );
  }

  Future<void> _onSignUp() async {
    // await ref.read(authenticationViewModelProvider.notifier).signUp();
  }

  void _toogleLoginSignUp() {
    _newUser = !_newUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(authenticationViewModelProvider);

      if (state.authenticated) {
        context.go('/context');
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(authenticationViewModelProvider);
    final viewModel = ref.read(authenticationViewModelProvider.notifier);

    final isError = state.error != null;
    final forgetPasswordValid = state.email.isNotEmpty &&
        state.emailValidationState == EmailValidationState.valid;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),

                    /// Logo
                    Center(
                      child: Image.asset(
                        'assets/icon/appIcon/app_icon.png',
                        height: 90,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Title
                    Text(
                      'Authenticate with AIDA',
                      style: GoogleFonts.baloo2(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Subtitle / Error
                    Text(
                      isError
                          ? (state.error ?? 'Authentication failed')
                          : 'Secure access to your AI workspace.',
                      style: GoogleFonts.quicksand(
                        fontSize: isError ? 14.5 : 15.5,
                        fontWeight: FontWeight.w400,
                        color: isError
                            ? colorScheme.error
                            : colorScheme.onSurface.withOpacity(.65),
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// Email
                    EmailInputWidget(
                      controller: viewModel.emailController,
                      onChanged: viewModel.setEmail,
                      // isEmailValid: state.isEmailValid,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                      emailValidationState: state.emailValidationState,
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    PasswordInputWidget(
                      controller: viewModel.passwordController,
                      onChanged: viewModel.setPassword,
                      focusNode: passwordFocusNode,
                      passwordValidationState: state.passwordValidationState,
                    ),

                    if (forgetPasswordValid) const SizedBox(height: 8),

                    if (forgetPasswordValid)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resetPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: colorScheme.outline.withOpacity(.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'or',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface.withOpacity(.6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: colorScheme.outline.withOpacity(.3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// Google Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _onGoogleAuthenticate,
                        icon: Image.asset(
                          'assets/icon/google_logo.png',
                          height: 20,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.onSurface,
                          side: BorderSide(
                            color: colorScheme.outline.withOpacity(.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            _newUser
                                ? 'Already have an account?'
                                : 'New to AIDA?',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withOpacity(.65),
                            ),
                          ),
                          TextButton(
                            onPressed: _toogleLoginSignUp,
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            child: Text(
                              _newUser ? 'Sign In' : 'Create Account',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom CTA
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: AuthenticateButtonWidget(
                  onPressed: _onAuthenticate,
                  enable: state.emailValidationState ==
                          EmailValidationState.valid &&
                      state.password.isNotEmpty,
                ),
              ),
            ),

            if (state.isLoading)
              Positioned.fill(
                child: Container(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

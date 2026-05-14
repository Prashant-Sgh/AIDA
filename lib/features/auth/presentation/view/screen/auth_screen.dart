import 'package:aida/features/auth/presentation/view/widgets/authenticate_button.dart';
import 'package:aida/features/auth/presentation/view/widgets/email_input.dart';
import 'package:aida/features/auth/presentation/view/widgets/password_input.dart';
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
  
  // void onAuthenticate() => ref.read(authenticationViewModelProvider.notifier).login();
  void onAuthenticate() => context.push('/otp');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((someValue) => Future.microtask(() {
              final state = ref.read(authenticationViewModelProvider);
              if (state.authenticated == true) {
                context.go('/context');
              }
            }));
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authenticationViewModelProvider);
    final viewModel = ref.read(authenticationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: true, // important
      body: SafeArea(
        child: Stack(
          children: [
            /// 📜 Scrollable Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120), // space for button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      "Welcome back 👋",
                      style: GoogleFonts.baloo2(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    EmailInputWidget(
                      controller: viewModel.emailController,
                      onChanged: viewModel.setEmail,
                      isEmailValid: state.isEmailValid,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                    ),
                    const SizedBox(height: 16),
                    PasswordInputWidget(
                      controller: viewModel.passwordController,
                      onChanged: viewModel.setPassword,
                      focusNode: passwordFocusNode,
                    ),
                  ],
                ),
              ),
            ),

            /// 🔘 Bottom Button (floating + keyboard aware)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: AuthenticateButtonWidget(
                  onPressed: () {
                    // viewModel.authenticate();
                    onAuthenticate();
                  },
                  enable: state.isEmailValid && state.password.isNotEmpty,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

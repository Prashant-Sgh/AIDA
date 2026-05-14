import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthenticationState>(
  (ref) => AuthenticationViewModel(),
);

class AuthenticationViewModel extends StateNotifier<AuthenticationState> {
  AuthenticationViewModel() : super(AuthenticationState());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  void setEmail(String value) {
    final isValid = isValidEmail(value);

    // _emailController.text = value;

    state = state.copyWith(
      email: value,
      isEmailValid: isValid,
    );
  }

  void setPassword(String value) {
    // _passwordController.text = value;
    state = state.copyWith(password: value);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  void resetOtpVerificationStatus() {
    state = state.copyWith(isOtpVerified: false);
  }

  Future<void> login() async {
    // Perform authentication logic here
    // You can use the email and password variables for authentication
    // Update the authentication status in the state
    state = state.copyWith(authenticated: true);
  }

  Future<void> logout() async {
    // Perform logout logic here
    // Reset the authentication status in the state
    state = state.copyWith(authenticated: false);
  }

  Future<void> verifyOtp(String otp) async {
    // Perform OTP verification logic here
    // Update the OTP verification status in the state
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 3));
    if (otp == '1234') {
      // depicts if response is success
      state = state.copyWith(isLoading: false, isOtpVerified: true);
    } else {
      state = state.copyWith(isLoading: false, isOtpVerified: false);
    }
  }
}

class AuthenticationState {
  AuthenticationState({
    this.isLoading = false,
    this.email = '',
    this.password = '',
    this.authenticated = false,
    this.isEmailValid = false,
    this.isOtpVerified = false,
  });

  bool isLoading = false;
  final String email;
  final String password;
  final bool authenticated;
  final bool isEmailValid;
  final bool isOtpVerified;

  AuthenticationState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    bool? authenticated,
    bool? isEmailValid,
    bool? isOtpVerified,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      authenticated: authenticated ?? this.authenticated,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }
}

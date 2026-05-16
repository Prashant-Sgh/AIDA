import 'package:aida/features/auth/data/repos/firebase_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthenticationState>(
  (ref) {
    final repo = ref.watch(firebaseAuthRepoProvider);
    return AuthenticationViewModel(repo);
  },
);

class AuthenticationViewModel extends StateNotifier<AuthenticationState> {
  final FirebaseAuthRepo _firebaseAuthRepo;
  AuthenticationViewModel(FirebaseAuthRepo firebaseAuthRepo)
      : _firebaseAuthRepo = firebaseAuthRepo,
        super(AuthenticationState());

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

  Future<void> loginAdmin({
    required String email,
    required String password,
  }) async {
    // Perform login logic here
    final response =
        await _firebaseAuthRepo.login(email: email, password: password);
    state = state.copyWith(
      authenticated: response.authenticated,
      error: response.error,
      email: response.email,
    );
  }

  Future<String?> getFirebaseIdToken() async {
    return await _firebaseAuthRepo.getFirebaseIdToken();
  }

  // Logout
  Future<void> logoutAdmin() async {
    await _firebaseAuthRepo.logout();
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
    this.error,
    this.authenticated = false,
    this.isEmailValid = false,
    this.isOtpVerified = false,
  });

  bool isLoading = false;
  final String email;
  final String password;
  final bool authenticated;
  final String? error;
  final bool isEmailValid;
  final bool isOtpVerified;

  AuthenticationState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    String? error,
    bool? authenticated,
    bool? isEmailValid,
    bool? isOtpVerified,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      authenticated: authenticated ?? this.authenticated,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }
}

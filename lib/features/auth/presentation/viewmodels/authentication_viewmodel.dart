import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/auth/data/repos/backend_2fa_repo.dart';
import 'package:aida/features/auth/data/repos/firebase_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthenticationState>(
  (ref) {
    final repo = ref.watch(firebaseAuthRepoProvider);
    final backend2faRepo = ref.watch(backend2faRepoProvider);
    return AuthenticationViewModel(repo, backend2faRepo);
  },
);

class AuthenticationViewModel extends StateNotifier<AuthenticationState> {
  final FirebaseAuthRepo _firebaseAuthRepo;
  final Backend2faRepo _backend2faRepo;
  AuthenticationViewModel(
      FirebaseAuthRepo firebaseAuthRepo, Backend2faRepo backend2faRepo)
      : _firebaseAuthRepo = firebaseAuthRepo,
        _backend2faRepo = backend2faRepo,
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

  Future<void> loginAdmin() async {
    // Perform login logic here
    final email = state.email;
    final password = state.password;

    final response =
        await _firebaseAuthRepo.login(email: email, password: password);

    if (response.authenticated) {
      final idToken = await getFirebaseIdToken();
      if (idToken != null) {
        state = state.copyWith(firebaseIdToken: idToken);
        await _backend2faRepo.start2fa(token: idToken);
      } else {
        state = state.copyWith(
            authenticated: false,
            error: 'No Firebase authentication token found.');
        logoutAdmin();
      }
    }

    state = state.copyWith(
      authenticated: response.authenticated,
      error: response.error,
      email: response.email,
    );
  }

  Future<String?> getFirebaseIdToken() async {
    final idToken = await _firebaseAuthRepo.getFirebaseIdToken();
    if (idToken != null) {
      state = state.copyWith(firebaseIdToken: idToken);
    }
    return idToken;
  }

  // Logout
  Future<void> logoutAdmin() async {
    await _firebaseAuthRepo.logout();
  }

  Future<void> reSendOtp() async{
    await _backend2faRepo.sendOTP(email: state.email);
  }

  Future<void> verifyOtp({required String otp}) async {
    state = state.copyWith(isLoading: true);
    final response = await _backend2faRepo.verifyOtp(otp: otp, email: state.email);
    if (response == ResponseState.success) {
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
    this.firebaseIdToken,
    this.isEmailValid = false,
    this.isOtpVerified = false,
  });

  bool isLoading = false;
  final String email;
  final String password;
  final bool authenticated;
  final String? firebaseIdToken;
  final String? error;
  final bool isEmailValid;
  final bool isOtpVerified;

  AuthenticationState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    String? error,
    bool? authenticated,
    String? firebaseIdToken,
    bool? isEmailValid,
    bool? isOtpVerified,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      authenticated: authenticated ?? this.authenticated,
      firebaseIdToken: firebaseIdToken ?? this.firebaseIdToken,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }
}

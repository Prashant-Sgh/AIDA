import 'package:aida/core/enums/response_state.dart';
import 'package:aida/core/services/secure_storage_service.dart';
import 'package:aida/features/auth/data/repos/backend_2fa_repo.dart';
import 'package:aida/features/auth/data/repos/firebase_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthenticationState>(
  (ref) {
    final repo = ref.watch(firebaseAuthRepoProvider);
    final backend2faRepo = ref.watch(backend2faRepoProvider);
    final secureStorageService = ref.watch(secureStorageServiceProvider);
    return AuthenticationViewModel(repo, backend2faRepo, secureStorageService);
  },
);

class AuthenticationViewModel extends StateNotifier<AuthenticationState> {
  final FirebaseAuthRepo _firebaseAuthRepo;
  final Backend2faRepo _backend2faRepo;
  final SecureStorageService _secureStorageService;

  AuthenticationViewModel(FirebaseAuthRepo firebaseAuthRepo,
      Backend2faRepo backend2faRepo, SecureStorageService secureStorageService)
      : _firebaseAuthRepo = firebaseAuthRepo,
        _backend2faRepo = backend2faRepo,
        _secureStorageService = secureStorageService,
        super(AuthenticationState());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  // Handle email and password changes
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

  // Login
  Future<void> loginAdmin() async {
    // Perform login logic here
    state = state.copyWith(isLoading: true);
    final response = await _firebaseAuthRepo.login(
        email: state.email, password: state.password);

    if (response.authenticated) {
      final idToken = await getFirebaseIdToken();
      if (idToken != null) {
        state = state.copyWith(
            isLoading: false, firebaseIdToken: idToken, error: null);
        await _backend2faRepo.start2fa(token: idToken);
      } else {
        state = state.copyWith(
            isLoading: false,
            authenticated: false,
            error: 'No Firebase authentication token found.');
        logoutAdmin();
      }
    } else {
      _emailController.clear();
      _passwordController.clear();
      state = state.copyWith(
        isLoading: false,
        authenticated: false,
        error: response.error,
        isEmailValid: false,
        email: '',
        password: '',
      );
    }
  }

  // Get Firebase ID Token
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
    await _secureStorageService.clearJwt();
    await _secureStorageService.clearFirebaseId();
    _emailController.clear();
    _passwordController.clear();
    state = state.copyWith(
        isEmailValid: false,
        email: null,
        password: null,
        firebaseIdToken: null,
        authenticated: false,
        isOtpVerified: false);
  }

  // Show OTP Pending Banner
  void showOtpPendingBanner() {
    state = state.copyWith(showOtpPendingBanner: true);
  }

  // Dismiss OTP Pending Banner
  void dismissOtpPendingBanner() {
    state = state.copyWith(showOtpPendingBanner: false);
  }

  // Resend OTP
  Future<void> reSendOtp() async {
    await _backend2faRepo.sendOTP(email: state.email);
  }

  // Verify OTP
  Future<void> verifyOtp({required String otp}) async {
    state = state.copyWith(isLoading: true);
    final response =
        await _backend2faRepo.verifyOtp(otp: otp, email: state.email);
    if (response.isNotEmpty) {
      final firebaseToken = await getFirebaseIdToken();
      _secureStorageService.saveJwt(jwtToken: response);
      _secureStorageService.saveFirebaseId(
          firebaseIdKey: firebaseToken ?? '');
      state = state.copyWith(
          isLoading: false, isOtpVerified: true, jwtToken: response);
    } else {
      state = state.copyWith(
          isLoading: false, isOtpVerified: false, error: "OTP invalid.");
    }
  }

  // Check Auth State
  Future<void> checkAuthState() async {
    final jwtToken = await _secureStorageService.getJwt();

    // 1. JWT exists
    if (jwtToken != null) {
      final valid = await _backend2faRepo.validateJwt(token: jwtToken);

      if (valid) {
        final firebaseToken = await getFirebaseIdToken();
        state = state.copyWith(
            authenticated: true,
            jwtToken: jwtToken,
            firebaseIdToken: firebaseToken,
            isOtpVerified: true);
        return;
      }
      _secureStorageService.clearJwt();
    }

    // 2. JWT doesn't exist Fall back to Firebase
    final firebaseToken = await getFirebaseIdToken();
    if (firebaseToken != null) {
      state = state.copyWith(
        authenticated: true,
        firebaseIdToken: firebaseToken,
        isOtpVerified: false,
      );
      showOtpPendingBanner();
      return;
    }

    state = state.copyWith(
      authenticated: false,
      firebaseIdToken: null,
      isOtpVerified: false,
    );
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
    this.showOtpPendingBanner = false,
    this.jwtToken,
  });

  bool isLoading = false;
  final String email;
  final String password;
  final bool authenticated;
  final String? firebaseIdToken;
  final String? error;
  final bool isEmailValid;
  final bool isOtpVerified;
  final bool showOtpPendingBanner;
  final String? jwtToken;

  AuthenticationState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    String? error,
    bool? authenticated,
    String? firebaseIdToken,
    bool? isEmailValid,
    bool? isOtpVerified,
    bool? showOtpPendingBanner,
    String? jwtToken,
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
      showOtpPendingBanner: showOtpPendingBanner ?? this.showOtpPendingBanner,
      jwtToken: jwtToken ?? this.jwtToken,
    );
  }
}

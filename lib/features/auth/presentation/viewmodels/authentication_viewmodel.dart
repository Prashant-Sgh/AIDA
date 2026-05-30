import 'package:aida/core/enums/response_state.dart';
import 'package:aida/core/services/secure_storage_service.dart';
import 'package:aida/features/auth/data/repos/backend_2fa_repo.dart';
import 'package:aida/features/auth/data/repos/firebase_auth_repo.dart';
import 'package:aida/features/auth/presentation/view/widgets/email_input.dart';
import 'package:aida/features/auth/presentation/view/widgets/password_input.dart';
import 'package:aida/features/otp/presentation/view/custom_banners/custom_otp_banner.dart';
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
    final validationState = validateEmail(value);

    // final isValid = validationState == EmailValidationState.valid;

    state = state.copyWith(
      email: value,
      // isEmailValid: isValid,
      emailValidationState: validationState,
    );
  }

  void setPassword(String value) {
    // _passwordController.text = value;
    state = state.copyWith(password: value, passwordValidationState: PasswordValidationState.none);
  }

  EmailValidationState validateEmail(String email) {
    if (email.isEmpty) {
      return EmailValidationState.initial;
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    // If it matches, it's valid
    if (emailRegex.hasMatch(email)) {
      return EmailValidationState.valid;
    }

    // If the user has typed something that *looks like* an email attempt
    // (contains '@' and at least one '.' after it), but fails regex → invalid
    if (email.contains('@') && email.split('@').length == 2) {
      final domainPart = email.split('@')[1];
      if (domainPart.contains('.')) {
        return EmailValidationState.invalid;
      }
    }

    // Otherwise, still in progress → initial
    return EmailValidationState.initial;
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
        await Future.delayed(const Duration(seconds: 1));
        state = state.copyWith(
          isLoading: false,
          firebaseIdToken: idToken,
          emailValidationState: EmailValidationState.valid,
          passwordValidationState: PasswordValidationState.valid,
          error: null,
        );
        await _backend2faRepo.start2fa(token: idToken);
      } else {
        state = state.copyWith(
            isLoading: false,
            authenticated: false,
            emailValidationState: EmailValidationState.invalid,
            passwordValidationState: PasswordValidationState.invalid,
            error: 'No Firebase authentication token found.');
        logoutAdmin();
      }
    } else  {
      // _emailController.clear();
      // _passwordController.clear();
      state = state.copyWith(
        isLoading: false,
        authenticated: false,
        error: response.error,
        // isEmailValid: false,
        emailValidationState: EmailValidationState.invalid,
        passwordValidationState: PasswordValidationState.invalid,
        // email: '',
        // password: '',
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
      emailValidationState: EmailValidationState.initial,
      passwordValidationState: PasswordValidationState.none,
      // isEmailValid: false,
      email: null,
      password: null,
      firebaseIdToken: null,
      authenticated: false,
      isOtpVerified: false,
    );
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
    if (response.jwtToken != null && response.jwtToken!.isNotEmpty) {
      final firebaseToken = await getFirebaseIdToken();
      _secureStorageService.saveJwt(jwtToken: response.jwtToken ?? '');
      _secureStorageService.saveFirebaseId(firebaseIdKey: firebaseToken ?? '');
      state = state.copyWith(
          isLoading: false, isOtpVerified: true, jwtToken: response.jwtToken);
    } else {
      state = state.copyWith(
          isLoading: false, isOtpVerified: false, error: "Invalid OTP");
    }

    switch (response.statusCode) {
      case 200:
        await setOtpBannerType(BannerType.successfullyVerified);
        break;
      case 401:
        await setOtpBannerType(BannerType.wrongOtp);
        break;
      case 410:
        await setOtpBannerType(BannerType.otpExpired);
      default:
        await setOtpBannerType(BannerType.tooManyAttempts);
    }
  }

  Future<void> setOtpBannerType(BannerType type) async {
    state = state.copyWith(otpBannerType: type, showOtpBannerType: true);
    await Future.delayed(const Duration(seconds: 7), () {
      closeOtpBannerType();
    });
  }

  void closeOtpBannerType() {
    state = state.copyWith(showOtpBannerType: false);
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
    // this.isEmailValid = false,
    this.emailValidationState = EmailValidationState.initial,
    this.passwordValidationState = PasswordValidationState.none,
    this.isOtpVerified = false,
    this.showOtpPendingBanner = false,
    this.jwtToken,
    this.showOtpBannerType = false,
    this.otpBannerType,
  });

  bool isLoading = false;
  final String email;
  final String password;
  final bool authenticated;
  final String? firebaseIdToken;
  final String? error;
  // final bool isEmailValid;
  final EmailValidationState emailValidationState;
  final PasswordValidationState passwordValidationState;
  final bool isOtpVerified;
  final bool showOtpPendingBanner;
  final String? jwtToken;
  final bool showOtpBannerType;
  final BannerType? otpBannerType;

  AuthenticationState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    String? error,
    bool? authenticated,
    String? firebaseIdToken,
    // bool? isEmailValid,
    EmailValidationState? emailValidationState,
    PasswordValidationState? passwordValidationState,
    bool? isOtpVerified,
    bool? showOtpPendingBanner,
    String? jwtToken,
    bool? showOtpBannerType,
    BannerType? otpBannerType,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      authenticated: authenticated ?? this.authenticated,
      firebaseIdToken: firebaseIdToken ?? this.firebaseIdToken,
      // isEmailValid: isEmailValid ?? this.isEmailValid,
      emailValidationState: emailValidationState ?? this.emailValidationState,
      passwordValidationState:
          passwordValidationState ?? this.passwordValidationState,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      showOtpPendingBanner: showOtpPendingBanner ?? this.showOtpPendingBanner,
      jwtToken: jwtToken ?? this.jwtToken,
      showOtpBannerType: showOtpBannerType ?? this.showOtpBannerType,
      otpBannerType: otpBannerType ?? this.otpBannerType,
    );
  }
}

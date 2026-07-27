import 'package:aida/features/auth/data/services/firebase_auth_services.dart';
import 'package:aida/features/auth/presentation/view/widgets/email_input.dart';
import 'package:aida/features/auth/presentation/view/widgets/password_input.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepoProvider = Provider<FirebaseAuthRepo>((ref) {
  final firebaseServiceProvider = ref.watch(firebaseAuthServicesProvider);
  return FirebaseAuthRepo(firebaseServiceProvider);
});

class FirebaseAuthRepo {
  final FirebaseAuthServices _firebaseAuthService;

  FirebaseAuthRepo(this._firebaseAuthService);

  Future<AuthenticationState> signUp({
    required String email,
    required String password,
  }) async {
    AuthenticationState authenticationState = AuthenticationState();

    authenticationState =
        authenticationState.copyWith(isLoading: true, error: null);
    try {
      await _firebaseAuthService.signUp(
        email: email,
        password: password,
      );
      authenticationState = authenticationState.copyWith(
        isLoading: false,
        email: email,
        emailValidationState: EmailValidationState.valid,
        passwordValidationState: PasswordValidationState.valid,
        authenticated: true,
        error: null,
      );
      return authenticationState;
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Something went wrong while signing up.';
          authenticationState = authenticationState.copyWith(
              // emailValidationState: EmailValidationState.invalid,
              // passwordValidationState: PasswordValidationState.invalid,
              );
          break;

        default:
          errorMessage =
              'Authentication failed: ${e.message ?? "Unknown error"}';
      }

      return authenticationState.copyWith(
        isLoading: false,
        authenticated: false,
        error: errorMessage,
      );
    }
  }

  // Login
  Future<AuthenticationState> login({
    required String email,
    required String password,
  }) async {
    AuthenticationState authenticationState = AuthenticationState();

    authenticationState =
        authenticationState.copyWith(isLoading: true, error: null);
    try {
      await _firebaseAuthService.login(
        email: email,
        password: password,
      );
      authenticationState = authenticationState.copyWith(
        isLoading: false,
        email: email,
        emailValidationState: EmailValidationState.valid,
        passwordValidationState: PasswordValidationState.valid,
        authenticated: true,
        error: null,
      );
      return authenticationState;
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      switch (e.code) {
        case 'invalid-credential':
          errorMessage =
              'Invalid email or password. If you forgot your password, reset it.';
          authenticationState = authenticationState.copyWith(
              // emailValidationState: EmailValidationState.invalid,
              // passwordValidationState: PasswordValidationState.invalid,
              );
          break;

        default:
          errorMessage =
              'Authentication failed: ${e.message ?? "Unknown error"}';
      }

      return authenticationState.copyWith(
        isLoading: false,
        authenticated: false,
        error: errorMessage,
      );
    }
  }

  // Get Firebase Id Token
  Future<String?> getFirebaseIdToken() async {
    return await _firebaseAuthService.getFirebaseIdToken();
  }

  // Get user email
  Future<String> getEmail({required String firebaseIdToken}) async {
    return await _firebaseAuthService.getEmail(firebaseIdToken: firebaseIdToken);
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuthService.logout();
  }

  // Continue with Google
  Future<UserCredential> continueWithGoogle() async {
    return await _firebaseAuthService.continueWithGoogle();
  }
}

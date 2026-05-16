import 'package:aida/features/auth/data/services/firebase_auth_services.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepoProvider = Provider<FirebaseAuthRepo>((ref) {
  final firebaseServiceProvider = ref.watch(firebaseAuthServicesProvider);
  return FirebaseAuthRepo(firebaseServiceProvider);
});

class FirebaseAuthRepo {
  final FirebaseAuthServices _firebaseAuthService;

  FirebaseAuthRepo(this._firebaseAuthService);

  
  void working() {
    debugPrint('working');
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
      return authenticationState.copyWith(
        isLoading: false,
        authenticated: true,
        email: email,
        error: null,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;

        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;

        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;

        default:
          errorMessage = e.message ?? 'Authentication failed';
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

  // Logout
  Future<void> logout() async {
    await _firebaseAuthService.logout();
  }
}

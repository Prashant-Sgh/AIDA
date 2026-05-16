import 'package:aida/features/auth/data/providers/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthServicesProvider = Provider<FirebaseAuthServices>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthServices(firebaseAuth);
});

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthServices(this._firebaseAuth);

  // Login using email & password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Get Firebase ID token
  Future<String?> getFirebaseIdToken() async {
    final user = _firebaseAuth.currentUser;
    final idToken = await user?.getIdToken();
    return idToken;
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

import 'package:aida/features/auth/data/providers/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthServicesProvider = Provider<FirebaseAuthServices>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthServices(firebaseAuth);
});

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthServices(this._firebaseAuth);

  // Sign up using email & password
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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

  // Get Email from firebase token
  Future<String> getEmail({required String firebaseIdToken}) async {
    final user =  _firebaseAuth.currentUser;
    final email = user?.email ?? '';
    return email;
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Continue with google
  Future<UserCredential> continueWithGoogle() async {
    if (kIsWeb) {
      return await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    }

    // Triger ther authenticatin flow
    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a credential
    final credential = GithubAuthProvider.credential(googleAuth.idToken ?? '');

    // Once signed in, return the UserCredential
    return await _firebaseAuth.signInWithCredential(credential);
  }
}

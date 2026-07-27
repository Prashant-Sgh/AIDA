import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthServicesProvider = Provider<FirebaseAuthServices>((ref) {
  return FirebaseAuthServices();
});

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // FirebaseAuthServices(this._firebaseAuth);

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
    final user = _firebaseAuth.currentUser;
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
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    return userCredential;
  }
}

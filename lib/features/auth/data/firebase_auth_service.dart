import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.message}');
      rethrow;
    }
  }

  Future<User?> signUp(
    String email,
    String password,
    String name,
    DateTime dob,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user != null) {
      await user.updateProfile(displayName: name);
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'dob': dob.toIso8601String(),
      });
    }
    return user;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      debugPrint('Google Sign In was cancelled by user');
      throw Exception('Google Sign In was cancelled by user');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    debugPrint(
      'Got auth details. Access token exists: ${googleAuth.accessToken != null}',
    );

    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      throw FirebaseAuthException(
        code: 'MISSING_GOOGLE_TOKEN',
        message: 'Missing Google auth tokens',
      );
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    final user = result.user;

    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'dob': '',
        });
      }
    }
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
}

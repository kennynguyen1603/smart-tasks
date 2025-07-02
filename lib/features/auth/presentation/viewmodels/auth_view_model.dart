import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, User?>(
  (ref) => AuthViewModel(),
);

class AuthViewModel extends StateNotifier<User?> {
  AuthViewModel() : super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = result.user;
    } on FirebaseAuthException catch (e) {
      print('Sign in failed: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    DateTime dob,
  ) async {
    final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      await user.updateProfile(displayName: name);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'dob': dob.toIso8601String(),
      });
      state = user;
    }
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'dob': '',
          'profilePicture': user.photoURL ?? '',
          'dateJoined': FieldValue.serverTimestamp(),
          'dateOfBirth': '',
          'bio': '',
          'isEmailVerified': user.emailVerified,
          'lastActive': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),

          'taskStats': {
            'tasksCompleted': 0,
            'tasksCreated': 0,
            'tasksInProgress': 0,
            'tasksOverdue': 0,
            'tasksUpcoming': 0,
            'tasksTotal': 0,
          },
        });
      }
      state = user;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    state = null;
  }
}

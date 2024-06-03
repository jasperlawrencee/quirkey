import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signupWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return creds.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        log('user not found');
      } else if (e.code == 'email-already-in-use') {
        log('account already exists');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        log('user with this email does not exist');
      } else if (e.code == 'wrong-password') {
        log('wrong password for that user');
      }
    }
    return null;
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

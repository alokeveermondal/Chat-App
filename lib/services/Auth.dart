import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user =  userCredential.user;
      return user;
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user =  userCredential.user;
      return user;
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    }
    catch(err) {
      print(err.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    }
    catch(err) {
      print(err.toString());
    }
  }
}
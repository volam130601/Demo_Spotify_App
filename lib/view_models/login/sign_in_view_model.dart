import 'package:demo_spotify_app/data/network/firebase/user_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../data/network/firebase/auth_google_service.dart';
import '../../models/firebase/user.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/toast_utils.dart';

class SignInViewModel with ChangeNotifier {
  Users user = Users();
  String email = '';
  String password = '';
  String validatorEmail = '';
  String validatorPassword = '';
  bool isCanSignIn = false;

  void fetchLogin() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (currentUser.email != null) {
      UserService.instance
          .getUser(FirebaseAuth.instance.currentUser!.email.toString())
          .then((value) {
        user = value;
        notifyListeners();
      });
    }
  }

  void signOut() {
    user = Users();
    email = '';
    password = '';
    validatorEmail = '';
    validatorPassword = '';
    isCanSignIn = false;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      final navigator = Navigator.of(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigator.pushReplacementNamed(RoutesName.home);
      ToastCommon.showCustomText(content: 'Login success');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
        isCanSignIn = false;
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
        isCanSignIn = false;
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Try again later.';
        isCanSignIn = false;
      } else {
        errorMessage = 'An error occurred. Please try again later.';
        isCanSignIn = false;
      }
      ToastCommon.showCustomText(content: errorMessage);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    {
      try {
        final navigator = Navigator.of(context);
        UserCredential userCredential = await AuthGoogle().signInWithGoogle();
        await UserService.instance.addUsers(Users(
            id: userCredential.user!.uid,
            displayName: userCredential.user!.displayName.toString(),
            email: userCredential.user!.email.toString(),
            photoUrl: userCredential.user!.photoURL.toString()));
        navigator.pushReplacementNamed(RoutesName.home);
        ToastCommon.showCustomText(content: 'Login with google is success');
      } catch (e) {
        ToastCommon.showCustomText(content: 'Login with google is ERROR');
      }
    }
  }

  void checkValidator() {
    int counter = 0;
    if (email.isEmpty) {
      validatorEmail = 'Email is required';
    } else if (!isValidEmail(email)) {
      validatorEmail = 'Invalid email address';
    } else if (email.isNotEmpty) {
      validatorEmail = '';
      counter++;
    }

    if (password.isEmpty) {
      validatorPassword = 'Password is required';
    } else if (password.length < 6) {
      validatorPassword = 'Password must be at least 6 characters long';
    } else {
      validatorPassword = '';
      counter++;
    }

    if (counter > 1) {
      isCanSignIn = true;
    } else {
      isCanSignIn = false;
    }
    notifyListeners();
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }
}

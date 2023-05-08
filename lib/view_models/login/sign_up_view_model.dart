import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../repository/remote/firebase/user_repository.dart';
import '../../widgets/custom_dialog.dart';

class SignUpViewModel with ChangeNotifier {
  String fullName = '';
  String email = '';
  String password = '';
  String _validatorFullName = '';
  String _validatorEmail = '';
  String _validatorPassword = '';
  bool _isCanSignUp = false;

  void checkValidator() {
    int counter = 0;

    if (email.isEmpty) {
      _validatorEmail = 'Email is required';
    } else if (!isValidEmail(email)) {
      _validatorEmail = 'Invalid email address';
    } else if (email.isNotEmpty) {
      _validatorEmail = '';
      counter++;
    }

    if (password.isEmpty) {
      _validatorPassword = 'Password is required';
    } else if (password.length < 6) {
      _validatorPassword = 'Password must be at least 6 characters long';
    } else {
      _validatorPassword = '';
      counter++;
    }

    if (fullName.isEmpty) {
      _validatorFullName = 'Full name is required';
    } else {
      _validatorFullName = '';
      counter++;
    }

    if (counter > 2) {
      _isCanSignUp = true;
    } else {
      _isCanSignUp = false;
    }
    notifyListeners();
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  void register(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserRepository.instance.registerUsernameAndPassword(
          userCredential: userCredential, displayName: fullName, email: email);
      // ignore: use_build_context_synchronously
      _showCustomDialog(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _validatorEmail = 'The account already exists for that email.';
        _isCanSignUp = false;
      } else if (e.code == 'invalid-email') {
        _validatorEmail = 'This email isn\'t valid';
        _isCanSignUp = false;
      } else {
        // General error
      }
      notifyListeners();
    } catch (e) {
      // General error
    }
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: CustomDiaLog(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      },
    );
  }

  bool get isCanSignUp => _isCanSignUp;

  String get validatorPassword => _validatorPassword;

  String get validatorEmail => _validatorEmail;

  String get validatorFullName => _validatorFullName;
}

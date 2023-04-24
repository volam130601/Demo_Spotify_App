import 'package:demo_spotify_app/utils/routes/route_name.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/network/firebase/user_service.dart';
import '../../utils/constants/default_constant.dart';
import 'components/form_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String _email = '';
  late String _password = '';
  late String _validatorEmail = '';
  late String _validatorPassword = '';

  final _scrollController = ScrollController();
  final _formSignInKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool _isCanSignIn = false;

  void checkValidator() {
    int counter = 0;
    setState(() {
      if (_email.isEmpty) {
        _validatorEmail = 'Email is required';
      } else if (!isValidEmail(_email)) {
        _validatorEmail = 'Invalid email address';
      } else if (_email.isNotEmpty) {
        _validatorEmail = '';
        counter++;
      }

      if (_password.isEmpty) {
        _validatorPassword = 'Password is required';
      } else if (_password.length < 6) {
        _validatorPassword = 'Password must be at least 6 characters long';
      } else {
        _validatorPassword = '';
        counter++;
      }

      if (counter > 1) {
        _isCanSignIn = true;
      } else {
        _isCanSignIn = false;
      }
    });
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding * 2),
          child: Form(
            key: _formSignInKey,
            child: Column(
              children: [
                FormInput(
                  title: 'E-Mail or username',
                  controller: _emailController,
                  validator: _validatorEmail,
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  scrollController: _scrollController,
                ),
                FormInput(
                  title: 'Password',
                  controller: _passwordController,
                  validator: _validatorPassword,
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                  scrollController: _scrollController,
                  isPassword: true,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      checkValidator();
                      if (_isCanSignIn) {
                        signIn(context, _email, _password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding * 2,
                            vertical: defaultPadding)),
                    child: Text(
                      'Log in',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserService().getUserById(userCredential.user!.uid);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(RoutesName.home);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login success',
            // ignore: use_build_context_synchronously
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
        _isCanSignIn = false;
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
        _isCanSignIn = false;
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Try again later.';
        _isCanSignIn = false;
      } else {
        errorMessage = 'An error occurred. Please try again later.';
        _isCanSignIn = false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

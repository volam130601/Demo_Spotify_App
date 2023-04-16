import 'package:demo_spotify_app/models/firebase/user.dart';
import 'package:demo_spotify_app/services/firebase/user_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/default_constant.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/slide_animation_page_route.dart';
import 'components/form_input.dart';
import 'main_login_screen.dart';

class SignUpFree extends StatefulWidget {
  const SignUpFree({Key? key}) : super(key: key);

  @override
  State<SignUpFree> createState() => _SignUpFreeState();
}

class _SignUpFreeState extends State<SignUpFree> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String _fullName = '';
  late String _email = '';
  late String _password = '';
  late String _validatorFullName = '';
  late String _validatorEmail = '';
  late String _validatorPassword = '';

  final _scrollController = ScrollController();
  final _formSignUpKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool _isCanSignUp = false;

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

      if (_fullName.isEmpty) {
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
    });
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create account',
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context)
                .push(SlideLeftPageRoute(page: const LoginScreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding * 2),
          child: Form(
            key: _formSignUpKey,
            child: Column(
              children: [
                FormInput(
                  title: 'Full name',
                  controller: _fullNameController,
                  validator: _validatorFullName,
                  onChanged: (value) {
                    setState(() {
                      _fullName = value.trim();
                    });
                  },
                  scrollController: _scrollController,
                ),
                FormInput(
                  title: 'E-Mail',
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
                      if (_isCanSignUp) {
                        register();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomDialog() {
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

  void register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final UserService userService = UserService();
      userService.addItem(
        Users(
          id: userCredential.user!.uid,
          displayName: _fullName,
          email: _email,
          photoUrl: '',
        ),
      );
      _showCustomDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _validatorEmail = 'The account already exists for that email.';
          _isCanSignUp = false;
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _validatorEmail = 'This email isn\'t valid';
          _isCanSignUp = false;
        });
      } else {
        // General error
      }
    } catch (e) {
      // General error
    }
  }
}

import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../res/components/slide_animation_page_route.dart';
import '../../res/constants/default_constant.dart';
import '../../services/firebase/firebase_auth_service.dart';
import '../../utils/routes/route_name.dart';
import 'login_screen.dart';

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
  final _obscureText = true;
  final _formSignUpKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool _isCanSignUp = false;

  void checkValidator() {
    int counter = 0;

    setState(() {

      if (_email.isEmpty) {
        _validatorEmail = 'Email is required';
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_email)) {
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
        _isCanSignUp = true;
      } else {
        _isCanSignUp = false;
      }
    });
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E-Mail',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    paddingHeight(0.5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius / 3),
                      ),
                      child: TextField(
                        controller: _emailController,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Colors.white,
                        cursorHeight: 24,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: const InputDecoration(
                          labelText: null,
                          errorText: null,
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(bottom: defaultPadding),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                      ),
                    ),
                    paddingHeight(0.3),
                    Text(
                      _validatorEmail ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.redAccent),
                    ),
                    paddingHeight(1),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    paddingHeight(0.5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius / 3),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Colors.white,
                        cursorHeight: 24,
                        obscureText: true,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: const InputDecoration(
                          labelText: null,
                          errorText: null,
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(bottom: defaultPadding),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                      ),
                    ),
                    paddingHeight(0.3),
                    Text(
                      _validatorPassword ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.redAccent),
                    ),
                    paddingHeight(1),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      checkValidator();
                      if (_isCanSignUp) {
                        registerTest();
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
        return  AlertDialog(
          content: CustomDiaLog(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      },
    );
  }
  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }
  void registerTest() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      // _showCustomDialog();
      if (!isValidEmail(_email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email address.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _validatorEmail = 'The account already exists for that email.';
          _isCanSignUp = false;
        });
      } else if (e.code == 'invalid-email') {
        // Invalid email address
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

class CustomDiaLog extends StatelessWidget {
  const CustomDiaLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsConsts.primaryColorDark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              ),
            ),
            child: const Icon(
              Ionicons.checkmark_circle_outline,
              size: 100,
              color: Colors.white,
            ),
          ),
          paddingHeight(1),
          Text(
            'Congratulations! Your sign up was successful.',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          paddingHeight(1),
          Text(
            'Do you want to log in now.',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          paddingHeight(2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: Text(
                  'Go to Login',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    SlideRightPageRoute(
                      page: const LayoutScreen(
                        index: 0,
                        screen: Placeholder(),
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
          paddingHeight(1),
        ],
      ),
    );
  }
}

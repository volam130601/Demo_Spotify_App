import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/views/login/main_login_screen.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import 'components/form_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInViewModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                SlideRightPageRoute(page: const LoginScreen())),
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
              key: _formSignInKey,
              child: Column(
                children: [
                  FormInput(
                    title: 'E-Mail or username',
                    controller: _emailController,
                    validator: value.validatorEmail,
                    onChanged: (newValue) => value.email = newValue.trim(),
                    scrollController: _scrollController,
                  ),
                  FormInput(
                    title: 'Password',
                    controller: _passwordController,
                    validator: value.validatorPassword,
                    onChanged: (v) {
                      value.password = v.trim();
                    },
                    scrollController: _scrollController,
                    isPassword: true,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        value.checkValidator();
                        if (value.isCanSignIn) {
                          value.signIn(context);
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
      ),
    );
  }
}

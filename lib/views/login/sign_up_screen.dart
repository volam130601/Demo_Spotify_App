import 'package:demo_spotify_app/view_models/login/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import '../../widgets/navigator/slide_animation_page_route.dart';
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
  final _scrollController = ScrollController();
  final _formSignUpKey = GlobalKey<FormState>();

  final SignUpViewModel signUpViewModel = SignUpViewModel();

  @override
  void dispose() {
    super.dispose();
    signUpViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, value, child) => Scaffold(
          appBar: buildAppBar(context),
          body: buildBody(value, context),
        ),
      ),
    );
  }

  SingleChildScrollView buildBody(SignUpViewModel value, BuildContext context) {
    return SingleChildScrollView(
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
                validator: value.validatorFullName,
                onChanged: (v) {
                  value.fullName = v.trim();
                },
                scrollController: _scrollController,
              ),
              FormInput(
                title: 'E-Mail',
                controller: _emailController,
                validator: value.validatorEmail,
                onChanged: (v) {
                  value.email = v.trim();
                },
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
                    if (value.isCanSignUp) {
                      value.register(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Create account',
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        onPressed: () async {
          Navigator.of(context)
              .pushReplacement(SlideLeftPageRoute(page: const LoginScreen()));
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}

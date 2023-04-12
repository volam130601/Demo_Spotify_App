import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/res/components/button_common.dart';
import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:demo_spotify_app/views/login/components/form_input.dart';
import 'package:demo_spotify_app/views/login/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/login_appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: loginAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: defaultPadding * 2),
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'If You Need Any Support',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w100, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Click Here',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ColorsConsts.deepPrimaryColor,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              const FormInputText(hintText: 'Full Name'),
              const SizedBox(height: defaultPadding),
              const FormInputText(hintText: 'Enter Email'),
              const SizedBox(height: defaultPadding),
              const FormInputPassword(hintText: 'Password'),
              const SizedBox(height: defaultPadding * 1.5),
              ButtonCommon(
                title: 'Create Account',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                isFitWidth: true,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              buildLine(context),
              const SizedBox(height: defaultPadding * 1.5),
              buildRowLogo(),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do You Have An Account',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SignInScreen()));
                    },
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildRowLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.network(
          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
          width: 30,
        ),
        const SizedBox(width: defaultPadding * 3),
        SvgPicture.network(
          'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
          width: 30,
          // ignore: deprecated_member_use
          color: Colors.grey,
        )
      ],
    );
  }

  Row buildLine(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 100,
            height: 1,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.grey.shade600,
                  Colors.grey.shade900,
                ])),
          ),
        ),
        Text(
          'Or',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: ColorsConsts.gradientGreyLight),
        ),
        Expanded(
          child: Container(
            width: 100,
            height: 1,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.grey.shade900,
                  Colors.grey.shade600,
                ])),
          ),
        ),
      ],
    );
  }
}

import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormInputText extends StatelessWidget {
  const FormInputText({
    super.key,
    required this.hintText,
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {},
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding * 2,
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(defaultBorderRadius * 2.5)),
      ),
    );
  }
}

class FormInputPassword extends StatefulWidget {
  const FormInputPassword({Key? key, required this.hintText}) : super(key: key);
  final String hintText;

  @override
  State<FormInputPassword> createState() => _FormInputPasswordState();
}

class _FormInputPasswordState extends State<FormInputPassword> {
  bool isShow = false;

  void setIsShow() {
    setState(() {
      isShow = !isShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {},
      keyboardType: TextInputType.text,
      obscureText: !isShow,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding * 2,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(defaultBorderRadius * 2.5),
        ),
        suffix: GestureDetector(
          onTap: () {
            setIsShow();
          },
          child: SizedBox(
            width: 40,
            child: isShow
                ? const Icon(
                    FontAwesomeIcons.eye,
                    color: Colors.grey,
                    size: 18,
                  )
                : const Icon(
                    FontAwesomeIcons.eyeSlash,
                    color: Colors.grey,
                    size: 18,
                  ),
          ),
        ),
      ),
    );
  }
}

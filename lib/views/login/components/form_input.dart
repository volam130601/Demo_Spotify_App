import 'package:flutter/material.dart';

import '../../../res/constants/default_constant.dart';

class FormInput extends StatefulWidget {
  const FormInput(
      {Key? key,
        required this.controller,
        required this.onChanged,
        required this.validator,
        required this.title,
        this.isPassword = false,
        required this.scrollController})
      : super(key: key);
  final TextEditingController controller;
  final Function(String) onChanged;
  final ScrollController scrollController;
  final String title;
  final String validator;
  final bool isPassword;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget textField = const TextField();
    if (widget.isPassword) {
      textField = TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        cursorHeight: 20,
        style: Theme.of(context).textTheme.titleMedium,
        decoration: InputDecoration(
          labelText: null,
          border: InputBorder.none,
          suffixIcon: ElevatedButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        onChanged: widget.onChanged,
        onTap: () {
          widget.scrollController
              .jumpTo(widget.scrollController.position.maxScrollExtent);
        },
      );
    } else {
      textField = TextField(
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        cursorHeight: 20,
        obscureText: widget.isPassword,
        style: Theme.of(context).textTheme.titleMedium,
        decoration: const InputDecoration(
          labelText: null,
          errorText: null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: defaultPadding),
        ),
        onChanged: widget.onChanged,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        paddingHeight(0.5),
        Container(
            padding: const EdgeInsets.only(left: defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(defaultBorderRadius / 3),
            ),
            child: textField
        ),
        paddingHeight(0.3),
        Text(
          widget.validator,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Colors.redAccent),
        ),
        paddingHeight(1),
      ],
    );
  }
}

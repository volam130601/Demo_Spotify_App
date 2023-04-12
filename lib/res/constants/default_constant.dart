import 'package:flutter/cupertino.dart';

const double defaultPadding = 16.0;
const double defaultBorderRadius = 12.0;

SizedBox paddingHeight([double number = 1.0]) {
  return SizedBox(height: defaultPadding * number);
}

SizedBox paddingWidth([double number = 1.0]) {
  return SizedBox(width: defaultPadding * number);
}

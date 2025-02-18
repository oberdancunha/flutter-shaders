import 'package:flutter/material.dart';

class UIColors {
  final double red;
  final double green;
  final double blue;

  factory UIColors({required Color baseColor}) =>
      UIColors._(red: baseColor.r, green: baseColor.g, blue: baseColor.b);

  UIColors._({required this.red, required this.green, required this.blue});

  Color getColor({required int adjustColor}) => Color.fromRGBO(
    _floatToInt8(red) + adjustColor,
    _floatToInt8(green) + adjustColor,
    _floatToInt8(blue) + adjustColor,
    1,
  );

  int _floatToInt8(double x) => (x * 255.0).round() & 0xff;
}

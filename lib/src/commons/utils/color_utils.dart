import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color color(String? value) {
    if (value == null || value.isEmpty) {
      return Colors.red;
    }

    if (value.contains('#')) {
      value = value.substring(value.indexOf('#') + 1);
    }

    var hex = 'FF00000'.substring(0, 8 - value.length) + value;
    return Color(int.parse(hex, radix: 16));
  }
}

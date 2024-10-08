import 'package:flutter/material.dart';

mixin SystemMode {
  static bool isDark(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    return brightness == Brightness.dark;
  }
}
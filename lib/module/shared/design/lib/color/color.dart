import 'package:saas_crm/index.dart';
import 'package:flutter/material.dart';

const lightBackground = Color(0xffFFFFFF);
const darkBackground = Color(0xff1A1C1E);

extension ColorMode on Color {
  static Color setColor({
    required BuildContext context,
    required Color light,
    required Color dark,
  }) {
    return SystemMode.isDark(context) ? dark : light;
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saas_crm/index.dart';

class CampingAnimation extends StatelessWidget {
  const CampingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AppAssets.pandaAnimation,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
      animate: true,
    );
  }
}

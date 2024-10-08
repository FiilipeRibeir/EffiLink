import 'package:flutter/material.dart';
import 'package:saas_crm/index.dart';
import 'package:go_router/go_router.dart';

class LoginRouter {
  static const root = '/login';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    );
  }
}

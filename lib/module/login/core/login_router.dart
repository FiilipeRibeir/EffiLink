import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saas_crm/index.dart';

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

class CreateRouter {
  static const root = '/create';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const CreatePage(),
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

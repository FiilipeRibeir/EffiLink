import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saas_crm/index.dart';

class HomeRouter {
  static const root = '/home';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const HomePage(),
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

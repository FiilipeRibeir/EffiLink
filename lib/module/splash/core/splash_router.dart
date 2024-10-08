import 'package:saas_crm/index.dart';
import 'package:go_router/go_router.dart';

class SplashRouter {
  static const root = '/';

  static GoRoute routes() {
    return GoRoute(
      path: root,
      builder: (context, state) {
        return const SplashPage();
      },
    );
  }
}

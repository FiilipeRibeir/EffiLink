import 'package:go_router/go_router.dart';
import 'package:saas_crm/index.dart';

class AppRouter {
  static GoRouter init() {
    return GoRouter(
      redirect: (context, state) {
        return null;
      },
      routes: [
        LoginRouter.routes(),
        CreateRouter.routes(),
        HomeRouter.routes(),
        OnboardingRouter.routes(),
        SplashRouter.routes(),
      ],
    );
  }
}

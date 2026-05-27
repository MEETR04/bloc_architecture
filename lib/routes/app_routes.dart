import 'package:auto_route/auto_route.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/routes/app_routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];
}

final appRouter = locator<AppRouter>();

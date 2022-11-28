import 'package:dd_study_22_ui/ui/roots/auth.dart';
import 'package:dd_study_22_ui/ui/roots/home.dart';
import 'package:dd_study_22_ui/ui/roots/loader.dart';
import 'package:flutter/cupertino.dart';

class NavigationRoute {
  static const loaderWidget = '/';
  static const authWidget = '/auth';
  static const homeWidget = '/home';
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toLoader() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.loaderWidget, (route) => false);
  }

  static void toAuth() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.authWidget, (route) => false);
  }

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.homeWidget, (route) => false);
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case NavigationRoute.loaderWidget:
        return PageRouteBuilder(
          pageBuilder: ((_, __, ___) => LoaderWidget.create()),
        );
      case NavigationRoute.authWidget:
        return PageRouteBuilder(
          pageBuilder: ((_, __, ___) => Auth.create()),
        );
      case NavigationRoute.homeWidget:
        return PageRouteBuilder(
          pageBuilder: ((_, __, ___) => const Home(title: 'Eblogram')),
        );
    }

    return null;
  }
}

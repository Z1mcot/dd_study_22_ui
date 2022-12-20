import 'package:dd_study_22_ui/ui/roots/app.dart';
import 'package:dd_study_22_ui/ui/roots/auth.dart';
import 'package:dd_study_22_ui/ui/roots/loader.dart';
import 'package:dd_study_22_ui/ui/profile/profile_widget.dart';
import 'package:flutter/cupertino.dart';

class NavigationRoute {
  static const loader = '/';
  static const auth = '/auth';
  static const app = '/app';
  static const profile = '/profile';
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.loader, (route) => false);
  }

  static Future toAuth() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.auth, (route) => false);
  }

  static Future toHome() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.app, (route) => false);
  }

  static Future toProfile() async {
    return key.currentState?.pushNamed(NavigationRoute.profile);
  }

  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case NavigationRoute.loader:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoaderWidget.create(),
        );
      case NavigationRoute.auth:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => Auth.create(),
        );
      case NavigationRoute.app:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => App.create(),
        );
      case NavigationRoute.profile:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ProfileWidget.create(),
        );
    }

    return null;
  }
}

import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/registration/sign_up.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/auth/auth.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/loader/loader.dart';
import 'package:flutter/material.dart';

class NavigationRoute {
  static const loader = '/';
  static const auth = '/auth';
  static const app = '/app';
  static const registration = "/registration";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static final navigationKeys = {
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.newContent: GlobalKey<NavigatorState>(),
    TabItemEnum.favourites: GlobalKey<NavigatorState>(),
    TabItemEnum.profile: GlobalKey<NavigatorState>(),
  };

  static Future toLoader() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.loader, (route) => false);
  }

  static Future toAuth() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.auth, (route) => false);
  }

  static Future toRegistration() async {
    return key.currentState?.pushNamed(NavigationRoute.registration);
  }

  static Future toHome() async {
    return key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoute.app, (route) => false);
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
      case NavigationRoute.registration:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SignUpWidget.create(),
        );
      case NavigationRoute.app:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => App.create(),
        );
    }

    return null;
  }
}

import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:dd_study_22_ui/ui/profile/profile_widget.dart';
import 'package:flutter/material.dart';

enum NavigationIconSelection { home, profile }

class AppBottomNavigationBar extends StatelessWidget {
  final NavigationIconSelection selectedIcon;
  final Function? onSelectedIconClick;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIcon,
    this.onSelectedIconClick,
  });

  static Future toProfile(BuildContext context) async {
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (newContext) => ProfileWidget.create()));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              if (selectedIcon != NavigationIconSelection.home) {
                AppNavigator.toHome();
              } else {
                onSelectedIconClick?.call();
              }
            },
            icon: selectedIcon == NavigationIconSelection.home
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
          ),
          IconButton(
            onPressed: () {
              if (selectedIcon != NavigationIconSelection.profile) {
                toProfile(context);
              }
            },
            icon: selectedIcon == NavigationIconSelection.profile
                ? const Icon(Icons.account_box)
                : const Icon(Icons.account_box_outlined),
          ),
        ],
      ),
    );
  }
}

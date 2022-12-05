import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';

enum NavigationIconSelection { home, profile }

class AppBottomNavigationBar extends StatelessWidget {
  final NavigationIconSelection selectedIcon;
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIcon,
  });

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
              }
            },
            icon: selectedIcon == NavigationIconSelection.home
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
          ),
          IconButton(
            onPressed: () {
              if (selectedIcon != NavigationIconSelection.profile) {
                AppNavigator.toProfile();
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

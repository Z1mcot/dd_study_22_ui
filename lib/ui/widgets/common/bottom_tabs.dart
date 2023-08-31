// import 'package:badges/badges.dart';
import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomTabs extends StatelessWidget {
  final TabItemEnum currentTab;
  final ValueChanged<TabItemEnum> onSelectTab;

  const BottomTabs({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  static Future toProfile(BuildContext context) async {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (newContext) => SelfProfile.create()));
  }

  @override
  Widget build(BuildContext context) {
    var appViewModel = context.watch<AppViewModel>();
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey,
      currentIndex: TabItemEnum.values.indexOf(currentTab),
      items:
          TabItemEnum.values.map((e) => _buildItem(e, appViewModel)).toList(),
      onTap: (value) {
        FocusScope.of(context).unfocus();
        var selectedTab = TabItemEnum.values[value];
        onSelectTab(selectedTab);
        // if (selectedTab == TabItemEnum.notifications) {
        //   appViewModel.notificationCounter = 0;
        // }
      },
    );
  }

  BottomNavigationBarItem _buildItem(
      TabItemEnum tabItem, AppViewModel appViewModel) {
    var isCurrent = currentTab == tabItem;
    var color = isCurrent ? Colors.grey[600] : Colors.grey[400];
    Widget? icon = Icon(
      TabEnums.tabIcon[tabItem],
      color: color,
      size: 25,
    );

    if (tabItem == TabItemEnum.profile) {
      icon = CircleAvatar(
        maxRadius: isCurrent ? 20 : 18,
        foregroundImage: appViewModel.avatar?.image,
      );
    }

    if (tabItem == TabItemEnum.notifications) {
      var counter = appViewModel.notificationCounter ?? 0;

      if (counter != 0) {
        icon = Badge(
          label: counter == 0 ? null : Text('$counter'),
          child: const Icon(Icons.favorite_outline),
        );
      }
    }

    return BottomNavigationBarItem(
        label: "",
        backgroundColor: isCurrent ? Colors.grey : Colors.transparent,
        icon: icon);
  }
}

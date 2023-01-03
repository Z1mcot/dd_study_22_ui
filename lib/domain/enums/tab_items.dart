import 'package:dd_study_22_ui/ui/widgets/tab_home/home.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search.dart';
import 'package:flutter/material.dart';

enum TabItemEnum {
  home,
  search,
  newPost,
  favourites,
  profile,
}

class TabEnums {
  static const TabItemEnum defaultTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newPost: Icons.add_photo_alternate_rounded,
    TabItemEnum.favourites: Icons.favorite_outline,
    TabItemEnum.profile: Icons.account_circle_outlined,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: Home.create(),
    TabItemEnum.search: Search.create(),
    TabItemEnum.profile: SelfProfile.create(),
  };
}

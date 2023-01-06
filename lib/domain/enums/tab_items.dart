// import 'package:dd_study_22_ui/ui/widgets/tab_create/new_post/new_post.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_create/create.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/home/home.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search.dart';
import 'package:flutter/material.dart';

enum TabItemEnum {
  home,
  search,
  newContent,
  favourites,
  profile,
}

class TabEnums {
  static const TabItemEnum defaultTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newContent: Icons.add_photo_alternate_rounded,
    TabItemEnum.favourites: Icons.favorite_outline,
    TabItemEnum.profile: Icons.account_circle_outlined,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: Home.create(),
    TabItemEnum.search: Search.create(),
    TabItemEnum.newContent: CreateWidget.create(),
    TabItemEnum.profile: SelfProfile.create(),
  };
}

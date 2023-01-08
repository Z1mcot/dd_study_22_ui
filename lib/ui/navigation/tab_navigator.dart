import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/subs_list/subs_list.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_create/new_post/new_post.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/edit_profile.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/info_edit/info_edit.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/password_change/password_change.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/profile/user_profile.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = "/app/";
  static const String postDetails = "/app/postDetail";

  static const String userProfile = "/app/userProfile";
  static const String userSubscribers = "/app/userProfile/subscribers";
  static const String userSubscriptions = "/app/userProfile/subscriptions";

  static const String createPost = "/app/createPost";
  static const String createStories = "/app/createStories";

  static const String editProfile = "/app/editProfile";
  static const String editProfileInfo = "/app/edit/profile";
  static const String changePassword = "/app/edit/password";
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItemEnum tabItem;
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.tabItem,
  });

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
          {TabNavigatiorArguments? args}) =>
      {
        TabNavigatorRoutes.root: (context) =>
            TabEnums.tabRoots[tabItem] ??
            SafeArea(
              child: Text(tabItem.name),
            ),
        // user stuff
        TabNavigatorRoutes.userProfile: (context) =>
            UserProfileWidget.create(args),
        TabNavigatorRoutes.userSubscribers: (context) => SubsList.create(
              args,
              listType: UserListTypeEnum.subscribersList,
            ),
        TabNavigatorRoutes.userSubscriptions: (context) => SubsList.create(
              args,
              listType: UserListTypeEnum.subscriptionsList,
            ),
        // all about posts
        TabNavigatorRoutes.postDetails: (context) => PostDetail.create(args),
        TabNavigatorRoutes.createPost: (context) => NewPost.create(),
        // all about editing user
        TabNavigatorRoutes.editProfile: (context) => EditProfileWidget.create(),
        TabNavigatorRoutes.editProfileInfo: (context) =>
            InfoEditWidget.create(),
        TabNavigatorRoutes.changePassword: (context) =>
            PasswordChangeWidget.create(),
      };

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        var rb = _routeBuilders(context,
            args: settings.arguments as TabNavigatiorArguments?);
        if (rb.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => rb[settings.name]!(context),
          );
        }

        return null;
      },
    );
  }
}

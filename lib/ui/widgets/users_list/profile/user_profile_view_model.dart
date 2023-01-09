import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/notification/send_notification_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/subscription/subscribe_model.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/profile/profile_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileViewModel extends ProfileViewModel {
  final String? userId;

  UserProfileViewModel({required super.context, required this.userId}) {
    asyncInit();

    buttonMsg = "Follow";

    gvc.addListener(() async {
      var max = gvc.position.maxScrollExtent;
      var current = gvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) async {
              var postCount = posts!.length;
              var newPosts =
                  await dataService.getUserPosts(user!.id, skip: postCount);
              posts = <PostModel>[...posts!, ...newPosts];
              isLoading = false;
            },
          );
        }
      }
    });

    var appViewModel = context.read<AppViewModel>();
    appViewModel.addListener(() {
      avatar = appViewModel.avatar;
    });
  }

  @override
  void asyncInit() async {
    try {
      var token = await TokenStorage.getAccessToken();
      headers = {"Authorization": "Bearer $token"};

      await SyncService().syncUserProfile(userId!);
      user = await dataService.getUserById(userId!);

      avatar = Image.network(
        "$baseUrl${user!.avatarLink}",
        headers: headers,
      );

      await SyncService().syncUserPosts(user!.id);
      posts = await dataService.getUserPosts(user!.id);
    } on DioError catch (e) {
      if (<int>[403].contains(e.response?.statusCode)) {
        errMsg = "This is private account";
      } else {
        errMsg = "User not found!";
      }
    } finally {
      buttonMsg = "Follow";
      buttonBackgroundColor = Colors.grey[200];
      buttonTextColor = Colors.black;
    }
  }

  @override
  void toPostDetail(String postId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.postDetails,
        arguments: TabNavigatiorArguments(
          postId: postId,
          userId: userId,
        ));
  }

  @override
  void toSubscribers() {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.userSubscribers,
        arguments: TabNavigatiorArguments(userId: user!.id));
  }

  @override
  void toSubscriptions() {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.userSubscriptions,
        arguments: TabNavigatiorArguments(userId: user!.id));
  }

  @override
  Widget getUserAvatar() {
    if (user!.avatarLink == null) {
      return const CircleAvatar(
        radius: 50,
        child: Icon(Icons.account_circle_rounded),
      );
    }

    if (avatar == null) {
      return const CircularProgressIndicator();
    }

    return CircleAvatar(radius: 50, foregroundImage: avatar?.image);
  }

  @override
  Future refreshView() async {
    asyncInit();
    notifyListeners();
  }

  @override
  void onProfileInfoButtonTap() async {
    if (user != null) {
      var model = SubscribeModel(authorId: user!.id);
      await api.subscribeToUser(model);

      if (user!.isPrivate == 1) {
        buttonBackgroundColor = Colors.black;
        buttonTextColor = Colors.white;
        buttonMsg = "Request sent";
      }
    }

    _sendPush("new follower", "just started following you");
  }

  _sendPush(String subtitle, String body) async {
    var sender = await SharedPrefs.getStoredUser();

    var alertModel = Alert(
        title: user!.name, subtitle: subtitle, body: "${user!.nameTag} $body");
    var pushModel = Push(alert: alertModel);
    var sendPushModel =
        SendNotificationModel(userId: sender!.id, push: pushModel);
    await api.sendPush("sub", null, sendPushModel);
  }
}

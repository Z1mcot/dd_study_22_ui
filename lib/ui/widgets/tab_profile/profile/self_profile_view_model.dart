import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/comment/post_comment.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_db.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_content.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SelfProfileViewModel extends ProfileViewModel {
  final _authService = AuthService();

  SelfProfileViewModel({required super.context}) {
    asyncInit();
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
              var oldPosts =
                  await dataService.getUserPosts(user!.id, skip: postCount);
              posts = <PostModel>[
                ...posts!,
                ...oldPosts,
              ];
              isLoading = false;
            },
          );
        }
      }
    });

    buttonBackgroundColor = Colors.grey[200];
    buttonTextColor = Colors.black;
    buttonMsg = "Edit profile";

    var appViewModel = context.read<AppViewModel>();
    appViewModel.addListener(() {
      avatar = appViewModel.avatar;
    });
  }

  @override
  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncUserPosts(user!.id);
    posts = await dataService.getUserPosts(user!.id);
  }

  String? _imagePath;

  Future changePhoto() async {
    var appViewModel = context.read<AppViewModel>();
    await Navigator.of(AppNavigator.key.currentState!.context)
        .push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CameraWidget(
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      avatar = null;
      var t = await api.uploadFiles(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await api.addAvatarToUser(t.first);

        var img = await NetworkAssetBundle(
                Uri.parse("$AppConfig.baseUrl${user!.avatarLink}"))
            .load("$AppConfig.baseUrl${user!.avatarLink}?v=1");
        var avatarImage = Image.memory(img.buffer.asUint8List());

        appViewModel.avatar = avatarImage;
      }
    }
  }

  void logout() async {
    await DB.instance.cleanTable<User>();
    await DB.instance.cleanTable<Post>();
    await DB.instance.cleanTable<PostContent>();
    await DB.instance.cleanTable<SimpleUser>();
    await DB.instance.cleanTable<PostComment>();
    await DB.instance.cleanTable<NotificationDb>();

    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  @override
  void toPostDetail(String postId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.postDetails,
        arguments: TabNavigatiorArguments(postId: postId, userId: user!.id));
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

    return GestureDetector(
        onTap: changePhoto,
        child: CircleAvatar(radius: 50, foregroundImage: avatar?.image));
  }

  @override
  Future refreshView() async {
    var refreshedUser = await api.getUser();
    SharedPrefs.setStoredUser(refreshedUser);
    asyncInit();
    notifyListeners();
  }

  @override
  void onProfileInfoButtonTap() {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.editProfile);
    refreshView();
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
}

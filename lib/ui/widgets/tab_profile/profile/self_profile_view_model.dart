import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';

import 'package:dd_study_22_ui/domain/models/post/post_content.dart';

import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SelfProfileViewModel extends ProfileViewModel {
  final _authService = AuthService();
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
              var newPosts =
                  await _dataService.getUserPosts(user!.id, skip: postCount);
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
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncUserPosts(user!.id);
    posts = await _dataService.getUserPosts(user!.id);
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
      var t = await _api.uploadFiles(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);

        var img =
            await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
                .load("$baseUrl${user!.avatarLink}?v=1");
        var avatarImage = Image.memory(img.buffer.asUint8List());

        appViewModel.avatar = avatarImage;
      }
    }
  }

  void logout() async {
    await DB.instance.cleanTable<User>();
    await DB.instance.cleanTable<Post>();
    await DB.instance.cleanTable<PostContent>();
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
    asyncInit();
    notifyListeners();
  }
}

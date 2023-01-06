import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileViewModel extends ProfileViewModel {
  final _dataService = DataService();
  String errMsg = "";

  final String? userId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserProfileViewModel({required super.context, required this.userId}) {
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
    try {
      var token = await TokenStorage.getAccessToken();
      headers = {"Authorization": "Bearer $token"};

      await SyncService().syncUserProfile(userId!);
      user = await _dataService.getUserById(userId!);

      avatar = Image.network(
        "$baseUrl${user!.avatarLink}",
        headers: headers,
      );

      await SyncService().syncUserPosts(user!.id);
      posts = await _dataService.getUserPosts(user!.id);
    } catch (exception) {
      errMsg = "User not found!";
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
}

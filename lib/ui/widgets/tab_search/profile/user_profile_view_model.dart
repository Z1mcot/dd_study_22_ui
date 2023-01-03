import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileViewModel extends ChangeNotifier {
  final BuildContext context;
  final _dataService = DataService();
  String errMsg = "";

  final String? userId;

  final _gvc = ScrollController();
  ScrollController get gvc => _gvc;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserProfileViewModel({required this.context, required this.userId}) {
    _asyncInit();

    _gvc.addListener(() async {
      var max = _gvc.position.maxScrollExtent;
      var current = _gvc.offset;
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

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? value) {
    _posts = value;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
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

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? value) {
    _avatar = value;
    notifyListeners();
  }

  void toPostDetail(String postId) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
  }
}

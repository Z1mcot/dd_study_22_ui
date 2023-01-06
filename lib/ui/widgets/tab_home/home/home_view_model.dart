import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/home_posts/posts_with_info.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends PostsWithInfo {
  BuildContext context;
  final _dataService = DataService();
  final _lvc = ScrollController();
  final _api = RepositoryModule.apiRepository();
  ScrollController get lvc => _lvc;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  HomeViewModel({required this.context}) {
    _asyncInit();
    _lvc.addListener(() async {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) async {
              var postCount = posts!.length;
              var newPosts =
                  await _dataService.getPosts(user!.id, skip: postCount);
              posts = <PostModel>[...posts!, ...newPosts];
              isLoading = false;
            },
          );
        }
      }
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? value) {
    _avatar = value;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};

    user = await SharedPrefs.getStoredUser();
    avatar = Image.network(
      "$baseUrl${user!.avatarLink}",
      fit: BoxFit.fill,
    );

    await SyncService().syncPosts();
    posts = await _dataService.getPosts(user!.id);
  }

  void onClick() {
    _lvc.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInCubic,
    );
  }

  void toPostDetail(String postId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.postDetails,
        arguments: TabNavigatiorArguments(postId: postId));
  }

  void toUserProfile(String userId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.userProfile,
        arguments: TabNavigatiorArguments(userId: userId));
  }

  @override
  void onLikeClick(String postId) {
    var likeModel = PostLikeModel(userId: user!.id, postId: postId);
    _api.likePost(likeModel);
    _asyncInit();
  }

  @override
  void onCommentClick(String commentId) {
    // TODO: implement onCommentClick
  }

  @override
  Future refreshView() async {
    _asyncInit();
    notifyListeners();
  }
}

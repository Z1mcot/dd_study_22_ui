import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/notification/send_notification_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/home_posts/posts_with_info.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PostDetailViewModel extends PostsWithInfo {
  BuildContext context;
  final _dataService = DataService();
  final _syncService = SyncService();
  final _api = RepositoryModule.apiRepository();

  var commentTec = TextEditingController();

  final _lvc = ScrollController();
  ScrollController get lvc => _lvc;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  PostDetailViewModelState _state = PostDetailViewModelState();
  PostDetailViewModelState get state => _state;
  set state(PostDetailViewModelState value) {
    _state = value;
    notifyListeners();
  }

  final String? postId;
  final String? userId;
  PostDetailViewModel({required this.context, this.postId, this.userId}) {
    _asyncInit();
    commentTec.addListener(() {
      state = state.copyWith(commentContent: commentTec.text);
    });

    _lvc.addListener(() async {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) async {
              var commentsCount = comments!.length;
              var newComments = await loadMoreComments(commentsCount);
              comments = <CommentModel>[...comments!, ...newComments];
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

  PostModel? _post;
  PostModel? get post => _post;
  set post(PostModel? val) {
    _post = val;
    notifyListeners();
  }

  List<CommentModel>? _comments;
  List<CommentModel>? get comments => _comments;
  set comments(List<CommentModel>? val) {
    _comments = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};

    user = await SharedPrefs.getStoredUser();
    if (user!.avatarLink != null) {
      var img =
          await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
              .load("$baseUrl${user!.avatarLink}?v=1");
      avatar = Image.memory(img.buffer.asUint8List(), fit: BoxFit.fill);
    }

    if (userId != null) {
      await _syncService.syncUserPosts(userId!);
    } else {
      await _syncService.syncPosts();
    }
    post = await _dataService.getPostById(postId!);

    await _syncService.syncPostComments(postId!);
    comments = await _dataService.getPostComments(postId: postId!);
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void toUserProfile(String userId) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: userId);
  }

  @override
  void onCommentClick(String commentId) {
    // TODO: implement onCommentClick
  }

  @override
  void onLikeClick(String postId) async {
    var likeModel = PostLikeModel(userId: user!.id, postId: postId);
    await _api.likePost(likeModel);
    await refreshView();

    _sendPush(postId, "new like", "left a like on your post!");
  }

  _sendPush(String postId, String subtitle, String body) async {
    var alertModel = Alert(
        title: user!.name, subtitle: subtitle, body: "${user!.nameTag} $body");
    var pushModel = Push(alert: alertModel);
    var sendPushModel =
        SendNotificationModel(userId: user!.id, push: pushModel);
    await _api.sendPush("post", postId, sendPushModel);
  }

  @override
  Future refreshView() async {
    _asyncInit();
    notifyListeners();
  }

  void addComment(String postId) async {
    var content = state.commentContent;
    if (content != null && content.isNotEmpty) {
      var model =
          AddCommentModel(authorId: user!.id, postId: postId, content: content);
      await _api.addComment(model);
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
      state.copyWith(commentContent: "");
      refreshView();

      _sendPush(postId, "new comment", "left comment under your post");
    }
  }

  Future<List<CommentModel>> loadMoreComments(int commentsCount) async {
    return await _api.getPostComments(post!.id, commentsCount, 10);
  }
}

class NotFoundException implements Exception {}

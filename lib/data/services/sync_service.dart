import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/domain/models/comment/post_comment.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_db.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';

class SyncService {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  Future syncPosts({int skip = 0, int take = 100}) async {
    var postModels = await _api.getPosts(skip, take);

    var authors = postModels.map((e) => e.author).toSet();
    var postContent = postModels
        .expand((x) => x.content.map((e) => e.copyWith(postId: x.id)))
        .toList();

    var posts = postModels
        .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id))
        .toList();

    await _dataService.rangeUpdateEntities(authors);
    await _dataService.rangeUpdateEntities(posts);
    await _dataService.rangeUpdateEntities(postContent);
  }

  Future syncUserPosts(String userProfileId) async {
    var postModels = await _api.getUserPosts(userProfileId, 0, 100);

    if (postModels.isNotEmpty) {
      var author = <SimpleUser>[postModels.first.author];
      var postContent = postModels
          .expand((x) => x.content.map((e) => e.copyWith(postId: x.id)))
          .toList();

      var posts = postModels
          .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id))
          .toList();

      await _dataService.rangeUpdateEntities(author);
      await _dataService.rangeUpdateEntities(posts);
      await _dataService.rangeUpdateEntities(postContent);
    }
  }

  Future syncUserProfile(String userProfileId) async {
    var user = await _api.getUserById(userProfileId);
    if (user != null) {
      await _dataService.createUpdateUser(user);
    }
  }

  Future syncPostComments(String postId) async {
    var commentModels = await _api.getPostComments(postId, 0, 100);
    var authors = commentModels.map((e) => e.author).toSet();

    var comments = commentModels.map((e) => PostComment.fromJson(e.toJson())
        .copyWith(authorId: e.author.id, postId: postId));

    await _dataService.rangeUpdateEntities(authors);
    await _dataService.rangeUpdateEntities(comments);
  }

  Future syncNotifications() async {
    var notifyModels = await _api.getNotifications(skip: 0, take: 100);

    var authors = notifyModels.map((e) => e.sender).toSet();
    var posts = <Post>[];
    for (var notify in notifyModels) {
      if (notify.postId != null) {
        PostModel? post;

        try {
          post = await _dataService.getPostById(notify.postId!);
        } catch (e) {
          post = await _api.getPostById(notify.postId!);
          _dataService.createUpdatePost(post);
        } finally {
          posts.add(Post.fromJson(post!.toJson()));
        }
      }
    }

    var notifies = notifyModels.map(
      (e) =>
          NotificationDb.fromJson(e.toJson()).copyWith(senderId: e.sender.id),
    );

    await _dataService.rangeUpdateEntities(notifies);
    await _dataService.rangeUpdateEntities(authors);
    //await _dataService.rangeUpdateEntities(posts);
  }
}

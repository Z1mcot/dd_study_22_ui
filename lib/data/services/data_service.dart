import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/comment/post_comment.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_db.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_content.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';

class DataService {
  Future createUpdateUser(User user) async {
    await DB.instance.createUpdate(user);
  }

  Future createUpdatePost(PostModel postModel) async {
    var post = Post.fromJson(postModel.toJson())
        .copyWith(authorId: postModel.author.id);

    DB.instance.createUpdate<Post>(post);
  }

  Future rangeUpdateEntities<T extends DbModel>(Iterable<T> elements) async {
    await DB.instance.createUpdateRange(elements);
  }

  Future<User> getUserById(String userId) async {
    var res = await DB.instance.get<User>(userId);
    if (res != null) return res;
    throw NotFoundException();
  }

  Future<List<PostModel>> getUserPosts(
    String userId, {
    int take = 10,
    int skip = 0,
  }) async {
    var res = <PostModel>[];
    var posts = await DB.instance.getAll<Post>(
        whereMap: {"authorId": userId},
        skip: skip,
        take: take,
        orderBy: "publishDate DESC");
    for (var post in posts) {
      var author = await DB.instance.get<SimpleUser>(post.authorId);
      var content =
          (await DB.instance.getAll<PostContent>(whereMap: {"postId": post.id}))
              .toList();
      if (author != null) {
        res.add(PostModel(
          id: post.id,
          author: author,
          content: content,
          publishDate: post.publishDate,
          description: post.description,
          likes: post.likes,
          comments: post.comments,
          isLiked: post.isLiked,
          isModified: post.isModified,
        ));
      }
    }

    return res;
  }

  Future<PostModel?> getPostById(String postId) async {
    var post = await DB.instance.get<Post>(postId);
    if (post != null) {
      var author = await DB.instance.get<SimpleUser>(post.authorId);
      var content =
          (await DB.instance.getAll<PostContent>(whereMap: {"postId": post.id}))
              .toList();
      if (author != null) {
        return PostModel(
          id: post.id,
          author: author,
          content: content,
          publishDate: post.publishDate,
          description: post.description,
          likes: post.likes,
          comments: post.comments,
          isLiked: post.isLiked,
          isModified: post.isModified,
        );
      }
    }

    throw NotFoundException();
  }

  Future<List<PostModel>> getPosts(
    String userId, {
    int take = 10,
    int skip = 0,
  }) async {
    var res = <PostModel>[];
    var posts = await DB.instance.getAll<Post>(
        whereMap: {"authorId": userId},
        invertWhereClause: true,
        take: take,
        skip: skip,
        orderBy: "publishDate DESC");
    for (var post in posts) {
      var author = await DB.instance.get<SimpleUser>(post.authorId);
      var content =
          (await DB.instance.getAll<PostContent>(whereMap: {"postId": post.id}))
              .toList();
      if (author != null) {
        res.add(PostModel(
          id: post.id,
          author: author,
          content: content,
          publishDate: post.publishDate,
          description: post.description,
          likes: post.likes,
          comments: post.comments,
          isLiked: post.isLiked,
          isModified: post.isModified,
        ));
      }
    }

    return res;
  }

  Future<List<NotificationModel>> getNotifications({
    int skip = 0,
    int take = 10,
  }) async {
    var res = <NotificationModel>[];
    var notifies =
        await DB.instance.getAll<NotificationDb>(skip: skip, take: take);

    for (var notify in notifies) {
      var sender = await DB.instance.get<SimpleUser>(notify.senderId);

      if (sender != null) {
        var model = NotificationModel(
          id: notify.id,
          sender: sender,
          description: notify.description,
          notifyDate: notify.notifyDate,
          postId: notify.postId,
        );
        if (model.postId != null) {
          var post = await getPostById(model.postId!);
          model = model.copyWith(post: post);
        }

        res.add(model);
      }
    }

    return res;
  }

  Future<List<CommentModel>> getPostComments({
    required String postId,
    int take = 10,
    int skip = 0,
  }) async {
    var res = <CommentModel>[];
    var comments = await DB.instance.getAll<PostComment>(
        whereMap: {"postId": postId}, take: take, skip: skip);

    for (var comment in comments) {
      var author = await DB.instance.get<SimpleUser>(comment.authorId);
      if (author != null) {
        res.add(CommentModel(
            id: comment.id,
            author: author,
            content: comment.content,
            likes: comment.likes,
            isLiked: comment.isLiked,
            publishDate: comment.publishDate));
      }
    }

    return res;
  }
}

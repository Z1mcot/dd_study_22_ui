import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail_view_model.dart';

class DataService {
  Future createUpdateUser(User user) async {
    await DB.instance.createUpdate(user);
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
    var posts = await DB.instance
        .getAll<Post>(whereMap: {"authorId": userId}, skip: skip, take: take);
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
        skip: skip);
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
        ));
      }
    }

    return res;
  }
}

import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';

class DataService {
  Future createUpdateUser(User user) async {
    await DB.instance.createUpdate(user);
  }

  Future rangeUpdateEntities<T extends DbModel>(Iterable<T> elements) async {
    await DB.instance.createUpdateRange(elements);
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    var res = <PostModel>[];
    var posts = await DB.instance.getAll<Post>(whereMap: {"authorId": userId});
    for (var post in posts) {
      var author = await DB.instance.get<User>(post.authorId);
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

  Future<List<PostModel>> getPosts(String userId) async {
    var res = <PostModel>[];
    var posts = await DB.instance
        .getAll<Post>(whereMap: {"authorId": userId}, invertWhereClause: true);
    for (var post in posts) {
      var author = await DB.instance.get<User>(post.authorId);
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

import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_like.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/post/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/token/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';

abstract class ApiRepository {
  // Tokens
  Future<TokenResponse?> getToken(
      {required String login, required String password, String? ip});

  Future<TokenResponse?> refreshToken(String refreshToken);

  //Users
  Future signUpUser(RegisterUserModel model);

  Future<User?> getUser();

  Future<User?> getUserById(String userId);

  Future<List<SimpleUser>> searchUsers(
      {required String nameTag, int skip = 0, int take = 10});

  // Posts
  Future<List<PostModel>> getPosts(int skip, int take);

  Future<List<PostModel>> getUserPosts(String userId, int skip, int take);

  Future createPost(CreatePostModel model);

  // Attachments
  Future<List<AttachMeta>> uploadFiles({required List<File> files});

  Future addAvatarToUser(AttachMeta model);

  // Comments
  Future addComment(AddCommentModel model);

  Future<List<CommentModel>> getPostComments(String postId, int skip, int take);

  // Likes
  Future likePost(PostLikeModel model);

  Future likeComment(CommentLikeModel model);
}

import 'dart:io';

import 'package:dd_study_22_ui/data/clients/api_client.dart';
import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_like.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/post/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/token/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/token/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  //Tokens
  @override
  Future<TokenResponse?> getToken(
      {required String login, required String password, String? ip}) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      password: password,
      ip: ip,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  //Users
  @override
  Future signUpUser(RegisterUserModel model) => _auth.signUpUser(model);

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<User?> getUserById(String userId) => _api.getUserById(userId);

  @override
  Future<List<SimpleUser>> searchUsers(
          {required String nameTag, int skip = 0, int take = 10}) =>
      _api.searchUsers(nameTag, skip, take);

  // Posts
  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future<List<PostModel>> getUserPosts(String userId, int skip, int take) =>
      _api.getUserPosts(userId, skip, take);

  @override
  Future createPost(CreatePostModel model) => _api.createPost(model);

  // Attachments
  @override
  Future<List<AttachMeta>> uploadFiles({required List<File> files}) =>
      _api.uploadFiles(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  // Comments
  @override
  Future addComment(AddCommentModel model) => _api.addComment(model);

  @override
  Future<List<CommentModel>> getPostComments(
          String postId, int skip, int take) =>
      _api.getPostComments(postId, skip, take);

  // Likes
  @override
  Future likeComment(CommentLikeModel model) => _api.likeComment(model);

  @override
  Future likePost(PostLikeModel model) => _api.likePost(model);
}

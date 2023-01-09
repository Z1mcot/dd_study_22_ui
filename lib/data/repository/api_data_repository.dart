import 'dart:io';

import 'package:dd_study_22_ui/data/clients/api_client.dart';
import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_like.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_model.dart';
import 'package:dd_study_22_ui/domain/models/notification/send_notification_model.dart';
import 'package:dd_study_22_ui/domain/models/post/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/session/user_session.dart';
import 'package:dd_study_22_ui/domain/models/subscription/subscribe_model.dart';
import 'package:dd_study_22_ui/domain/models/token/push_token.dart';
import 'package:dd_study_22_ui/domain/models/token/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/token/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user/change_user_password_model.dart';
import 'package:dd_study_22_ui/domain/models/user/modify_user_info_model.dart';
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

  @override
  Future changePassword(ChangeUserPasswordModel model) =>
      _api.changePassword(model);

  @override
  Future modifyUserInfo(ModifyUserInfoModel model) =>
      _api.modifyUserInfo(model);

  // Subscriptions
  @override
  Future subscribeToUser(SubscribeModel model) => _api.subscribeToUser(model);

  @override
  Future<List<SimpleUser>> getSubscribers(
          {required String userId, int skip = 0, int take = 10}) =>
      _api.getSubscribers(userId, skip, take);

  @override
  Future<List<SimpleUser>> getSubscribtions(
          {required String userId, int skip = 0, int take = 10}) =>
      _api.getSubscribtions(userId, skip, take);

  @override
  Future confirmSubscription(String userId) => _api.confirmSubscription(userId);

  // Posts
  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future<List<PostModel>> getUserPosts(String userId, int skip, int take) =>
      _api.getUserPosts(userId, skip, take);

  @override
  Future<PostModel> getPostById(String postId) => _api.getPostById(postId);

  @override
  Future createPost(CreatePostModel model) => _api.createPost(model);

  @override
  Future deletePost(String postId) => _api.deletePost(postId);

  // Attachments
  @override
  Future<List<AttachMeta>> uploadFiles({required List<File> files}) =>
      _api.uploadFiles(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  // Comments
  @override
  Future<List<CommentModel>> getPostComments(
          String postId, int skip, int take) =>
      _api.getPostComments(postId, skip, take);

  @override
  Future addComment(AddCommentModel model) => _api.addComment(model);

  @override
  Future deleteComment(String commentId) => _api.deleteComment(commentId);

  // Likes
  @override
  Future likeComment(CommentLikeModel model) => _api.likeComment(model);

  @override
  Future likePost(PostLikeModel model) => _api.likePost(model);

  // Sessions
  @override
  Future<List<UserSession>> getSessions() => _api.getSessions();

  @override
  Future deactivateSession(String refreshToken) =>
      _api.deactivateSession(refreshToken);

  // pushes
  @override
  Future subscribeToNotifications(PushToken model) =>
      _api.subscribeToNotifications(model);

  @override
  Future unsubscribeFromNotifications() => _api.unsubscribeFromNotifications();

  @override
  Future sendPush(
          String notifyType, String? postId, SendNotificationModel model) =>
      _api.sendPush(notifyType, postId, model);

  // notifications
  @override
  Future<List<NotificationModel>> getNotifications(
          {int skip = 0, int take = 10}) =>
      _api.getNotifications(skip, take);
}

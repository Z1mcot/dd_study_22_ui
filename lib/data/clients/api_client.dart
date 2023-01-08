import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_like.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/post/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/session/user_session.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/subscription/subscribe_model.dart';
import 'package:dd_study_22_ui/domain/models/user/change_user_password_model.dart';
import 'package:dd_study_22_ui/domain/models/user/modify_user_info_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // Users
  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/User/GetUserProfile")
  Future<User?> getUserById(@Query("userId") String userId);

  @GET("/api/User/SearchUsers")
  Future<List<SimpleUser>> searchUsers(@Query("nameTag") String nameTag,
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/User/ChangeCurrentUserPassword")
  Future changePassword(@Body() ChangeUserPasswordModel model);

  @POST("/api/User/ModifyUserInfo")
  Future modifyUserInfo(@Body() ModifyUserInfoModel model);

  // Subscriptions
  @POST("/api/Subscription/SubscribeToUser")
  Future subscribeToUser(@Body() SubscribeModel model);

  @GET("/api/Subscription/GetUserSubscribers")
  Future<List<SimpleUser>> getSubscribers(@Query("userId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Subscription/GetUserSubscriptions")
  Future<List<SimpleUser>> getSubscribtions(@Query("userId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/Subscription/ConfirmSubRequest")
  Future confirmSubscription(@Query("userId") String userId);

  // Posts
  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/ShowUserPosts")
  Future<List<PostModel>> getUserPosts(@Query("authorId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);

  @POST("/api/Post/DeletePost")
  Future deletePost(@Query("postId") String postId);

  // Attchments
  @MultiPart()
  @POST("/api/Attachment/UploadFiles")
  Future<List<AttachMeta>> uploadFiles(
      {@Part(name: "files") required List<File> files});

  @POST("/api/Attachment/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);

  // Comments
  @GET("/api/Post/ShowComments")
  Future<List<CommentModel>> getPostComments(@Query("postId") String postId,
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/Post/AddCommentToPost")
  Future addComment(@Body() AddCommentModel model);

  @POST("/api/Post/DeleteComment")
  Future deleteComment(@Query("commentId") String commentId);

  // Likes
  @POST("/api/Post/LikePost")
  Future likePost(@Body() PostLikeModel model);

  @POST("/api/Post/LikeComment")
  Future likeComment(@Body() CommentLikeModel model);

  // Sessions
  @GET("/api/User/GetCurrentSessions")
  Future<List<UserSession>> getSessions();

  @POST("/api/User/DeactivateSession")
  Future deactivateSession(@Query("refreshToken") String refreshToken);
}

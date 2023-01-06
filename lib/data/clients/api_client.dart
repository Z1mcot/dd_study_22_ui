import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/comment/add_comment.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_like.dart';
import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/post/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/post/post_like.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // User
  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/User/GetUserProfile")
  Future<User?> getUserById(@Query("userId") String userId);

  @GET("/api/User/SearchUsers")
  Future<List<SimpleUser>> searchUsers(@Query("nameTag") String nameTag,
      @Query("skip") int skip, @Query("take") int take);

  // Post
  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);

  @GET("/api/Post/ShowUserPosts")
  Future<List<PostModel>> getUserPosts(@Query("authorId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  // Attchment
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

  // Likes
  @POST("/api/Post/LikePost")
  Future likePost(@Body() PostLikeModel model);

  @POST("/api/Post/LikeComment")
  Future likeComment(@Body() CommentLikeModel model);
}

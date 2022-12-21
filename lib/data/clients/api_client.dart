import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);

  @MultiPart()
  @POST("/api/Attachment/UploadFiles")
  Future<List<AttachMeta>> uploadFiles(
      {@Part(name: "files") required List<File> files});

  @POST("/api/Attachment/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);
}

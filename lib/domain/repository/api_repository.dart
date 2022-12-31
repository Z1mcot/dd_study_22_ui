import 'dart:io';

import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password, String? ip});

  Future<TokenResponse?> refreshToken(String refreshToken);

  Future signUpUser(RegisterUserModel model);

  Future<User?> getUser();

  Future<List<PostModel>> getPosts(int skip, int take);

  Future<List<PostModel>> getUserPosts(String userId, int skip, int take);

  Future<List<AttachMeta>> uploadFiles({required List<File> files});

  Future addAvatarToUser(AttachMeta model);

  Future createPost(CreatePostModel model);
}

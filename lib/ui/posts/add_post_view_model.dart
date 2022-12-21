import 'dart:io';

import 'package:dd_study_22_ui/domain/models/create_post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';

class AddPostViewModel extends ChangeNotifier {
  final BuildContext context;

  final _api = RepositoryModule.apiRepository();

  var descriptionTec = TextEditingController();

  AddPostViewModel({required this.context}) {
    _asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }

  void publishPost(List<File> images) async {
    if (images.isNotEmpty) {
      var content = await _api.uploadFiles(files: images);
      if (content.isNotEmpty) {
        await _api.createPost(CreatePostModel(
            authorId: user!.id,
            content: content,
            description: descriptionTec.text));
      }
    }

    await AppNavigator.toHome();
  }
}
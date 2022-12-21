import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:dd_study_22_ui/ui/common/camera_widget.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final BuildContext context;
  final _authService = AuthService();
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  ProfileViewModel({required this.context}) {
    _asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? value) {
    _posts = value;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  String? _imagePath;
  String? get imagePath => _imagePath;
  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  Future changePhoto() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CameraWidget(
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      var t = await _api.uploadFiles(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);
      }
    }
  }

  void logout() async {
    await DB.instance.cleanTable<User>();
    await DB.instance.cleanTable<Post>();
    await DB.instance.cleanTable<PostContent>();
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }
}

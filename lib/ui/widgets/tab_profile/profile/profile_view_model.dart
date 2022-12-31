import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final BuildContext context;
  final _authService = AuthService();
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  ProfileViewModel({required this.context}) {
    _asyncInit();
    var appViewModel = context.read<AppViewModel>();
    appViewModel.addListener(() {
      avatar = appViewModel.avatar;
    });
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

  void _asyncInit() async {
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncUserPosts(user!.id);
    posts = await _dataService.getUserPosts(user!.id);
  }

  String? _imagePath;
  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? value) {
    _avatar = value;
    notifyListeners();
  }

  Future changePhoto() async {
    var appViewModel = context.read<AppViewModel>();
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
      avatar = null;
      var t = await _api.uploadFiles(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);

        var img =
            await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
                .load("$baseUrl${user!.avatarLink}?v=1");
        var avatarImage = Image.memory(img.buffer.asUint8List());

        appViewModel.avatar = avatarImage;
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

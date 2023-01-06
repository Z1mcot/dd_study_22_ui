import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:flutter/material.dart';

abstract class ProfileViewModel extends ChangeNotifier {
  final BuildContext context;

  final _gvc = ScrollController();
  ScrollController get gvc => _gvc;

  ProfileViewModel({required this.context});

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

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? value) {
    _avatar = value;
    notifyListeners();
  }

  void asyncInit();

  void toPostDetail(String postId);

  Future refreshView();

  Widget getUserAvatar();
}

import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';

abstract class ProfileViewModel extends ChangeNotifier {
  final BuildContext context;
  final dataService = DataService();
  final api = RepositoryModule.apiRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _errMsg;
  String? get errMsg => _errMsg;
  set errMsg(String? value) {
    _errMsg = value;
    notifyListeners();
  }

  String? _buttonMsg;
  String? get buttonMsg => _buttonMsg;
  set buttonMsg(String? value) {
    _buttonMsg = value;
    notifyListeners();
  }

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

  Color? _buttonBackgroundColor;
  Color? get buttonBackgroundColor => _buttonBackgroundColor;
  set buttonBackgroundColor(Color? value) {
    _buttonBackgroundColor = value;
    notifyListeners();
  }

  Color? _buttonTextColor;
  Color? get buttonTextColor => _buttonTextColor;
  set buttonTextColor(Color? value) {
    _buttonTextColor = value;
    notifyListeners();
  }

  void asyncInit();

  void toPostDetail(String postId);

  void toSubscribers();

  void toSubscriptions();

  Future refreshView();

  Widget getUserAvatar();

  void onProfileInfoButtonTap();

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

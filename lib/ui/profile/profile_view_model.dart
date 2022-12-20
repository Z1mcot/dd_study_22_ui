import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/database.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();

  ProfileViewModel({required this.context}) {
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

  void logout() async {
    await DB.instance.cleanTable();
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }
}

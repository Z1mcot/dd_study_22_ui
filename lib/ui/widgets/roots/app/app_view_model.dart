import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  AppViewModel({required this.context}) {
    _asyncInit();
  }

  bool isBottomBarVisible = true;

  var _currentTab = TabEnums.defaultTab;
  TabItemEnum? previousTab;
  TabItemEnum get currentTab => _currentTab;
  void selectTab(TabItemEnum tabItemEnum) {
    if (tabItemEnum == _currentTab) {
      AppNavigator.navigationKeys[tabItemEnum]!.currentState!
          .popUntil((route) => route.isFirst);
    } else {
      previousTab = _currentTab;
      _currentTab = tabItemEnum;
      notifyListeners();
    }
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? value) {
    _avatar = value;
    notifyListeners();
  }

  String? _msg;
  String? get msg => _msg;
  set msg(String? val) {
    _msg = val;
    if (val != null) {
      showSnackBar(val);
    }
    notifyListeners();
  }

  void _asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    if (user!.avatarLink != null) {
      var img =
          await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
              .load("$baseUrl${user!.avatarLink}?v=1");
      avatar = Image.memory(img.buffer.asUint8List(), fit: BoxFit.fill);
    }
    imagePaths = <String>[];
  }

  showSnackBar(String text) {
    var sb = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(sb);
  }

  List<String>? _imagePaths;
  List<String>? get imagePaths => _imagePaths;
  set imagePaths(List<String>? value) {
    _imagePaths = value;
    notifyListeners();
  }
}

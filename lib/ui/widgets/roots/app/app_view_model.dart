import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  AppViewModel({required this.context}) {
    _asyncInit();
  }

  bool isBottomBarVisible = true;

  final navigationKeys = {
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.newContent: GlobalKey<NavigatorState>(),
    TabItemEnum.favourites: GlobalKey<NavigatorState>(),
    TabItemEnum.profile: GlobalKey<NavigatorState>(),
  };

  var _currentTab = TabEnums.defaultTab;
  TabItemEnum? previousTab;
  TabItemEnum get currentTab => _currentTab;
  void selectTab(TabItemEnum tabItemEnum) {
    if (tabItemEnum == _currentTab) {
      navigationKeys[tabItemEnum]!
          .currentState!
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

  List<String>? _imagePaths;
  List<String>? get imagePaths => _imagePaths;
  set imagePaths(List<String>? value) {
    _imagePaths = value;
    notifyListeners();
  }
}

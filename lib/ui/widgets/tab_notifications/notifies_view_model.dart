import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/enums/tab_items.dart';
import 'package:dd_study_22_ui/domain/models/notification/notification_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
// import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifiesViewModel extends ChangeNotifier {
  BuildContext context;
  final _dataService = DataService();
  // final _api = RepositoryModule.apiRepository();

  NotifiesViewModel({required this.context}) {
    _asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Map<String, String>? headers;

  List<NotificationModel>? _notifications;
  List<NotificationModel>? get notifications => _notifications;
  set notifications(List<NotificationModel>? value) {
    _notifications = value;
    notifyListeners();
  }

  int? _notificationCounter;
  int? get notificationCounter => _notificationCounter;
  set notificationCounter(int? value) {
    _notificationCounter = value;
    notifyListeners();
  }

  void _asyncInit() async {
    user = await SharedPrefs.getStoredUser();

    await SyncService().syncNotifications();
    notifications = await _dataService.getNotifications();
  }

  void toPostDetail(String postId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.postDetails,
        arguments: TabNavigatiorArguments(postId: postId, userId: user!.id));
  }

  void toUserProfile(String userId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.userProfile,
        arguments: TabNavigatiorArguments(userId: userId));
  }

  Future refreshView() async {
    _asyncInit();
    clearNotifiesCounter();
    notifyListeners();
  }

  clearNotifiesCounter() {
    var ctx = AppNavigator.navigationKeys[TabItemEnum.home]?.currentContext;
    if (ctx != null) {
      var appviewModel = ctx.read<AppViewModel>();
      appviewModel.notificationCounter = 0;
    }
  }
}

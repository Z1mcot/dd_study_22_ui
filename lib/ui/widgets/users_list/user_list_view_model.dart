import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:flutter/cupertino.dart';

abstract class UserListViewModel extends ChangeNotifier {
  BuildContext context;

  final _api = RepositoryModule.apiRepository();
  ApiRepository get api => _api;

  final _lvc = ScrollController();
  ScrollController get lvc => _lvc;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserListViewModel({required this.context});

  List<SimpleUser>? _users;
  List<SimpleUser>? get users => _users;
  set users(List<SimpleUser>? value) {
    _users = value;
    notifyListeners();
  }

  List<SimpleUser>? _newUsers;
  List<SimpleUser>? get newUsers => _newUsers;
  set newUsers(List<SimpleUser>? val) {
    _newUsers = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit();

  Future getUsers();

  void loadMoreUsers(int skip);

  void toUserProfile(String userId) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.userProfile,
        arguments: TabNavigatiorArguments(userId: userId));
  }
}

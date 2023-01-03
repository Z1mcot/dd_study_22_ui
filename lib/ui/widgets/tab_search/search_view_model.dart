import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search_view_model_state.dart';
import 'package:flutter/cupertino.dart';

class SearchViewModel extends ChangeNotifier {
  BuildContext context;
  final _api = RepositoryModule.apiRepository();
  var searchTec = TextEditingController();
  final _lvc = ScrollController();
  ScrollController get lvc => _lvc;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  SearchViewModel({required this.context}) {
    _asyncInit();
    searchTec.addListener(() {
      state = state.copyWith(nameTag: searchTec.text);
    });

    _lvc.addListener(() async {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) {
              var usersCount = foundUsers!.length;
              loadMoreUsers(usersCount);
              foundUsers = <SimpleUser>[...foundUsers!, ...newUsers!];
              isLoading = false;
            },
          );
        }
      }
    });
  }

  SearchViewModelState _state = SearchViewModelState();

  SearchViewModelState get state => _state;
  set state(SearchViewModelState value) {
    _state = value;
    notifyListeners();
  }

  List<SimpleUser>? _foundUsers;
  List<SimpleUser>? get foundUsers => _foundUsers;
  set foundUsers(List<SimpleUser>? value) {
    _foundUsers = value;
    notifyListeners();
  }

  List<SimpleUser>? _newUsers;
  List<SimpleUser>? get newUsers => _newUsers;
  set newUsers(List<SimpleUser>? val) {
    _newUsers = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void _asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
  }

  void clearSearch() {
    searchTec.text = "";
    foundUsers = null;
  }

  Future getUsers() async {
    var searchQuery = state.nameTag;
    if (searchQuery != null) {
      if (!searchQuery.startsWith("@")) {
        searchQuery = "@$searchQuery";
      }

      if (!isLoading) {
        isLoading = true;

        if (searchQuery.isNotEmpty) {
          foundUsers =
              await _api.searchUsers(nameTag: searchQuery, skip: 0, take: 10);
        } else {
          foundUsers = null;
        }

        isLoading = false;
      }
    }
  }

  void loadMoreUsers(int skip) async {
    var searchQuery = state.nameTag;
    if (searchQuery != null) {
      newUsers =
          await _api.searchUsers(nameTag: state.nameTag!, skip: skip, take: 10);
    }
  }

  void toUserProfile(String userId) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.userProfile, arguments: userId);
  }
}

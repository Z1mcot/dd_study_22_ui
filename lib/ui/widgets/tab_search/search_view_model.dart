import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search_view_model_state.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/user_list_view_model.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends UserListViewModel {
  var searchTec = TextEditingController();

  SearchViewModel({required super.context}) {
    asyncInit();
    searchTec.addListener(() {
      state = state.copyWith(nameTag: searchTec.text);
    });

    lvc.addListener(() async {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
      var percent = current / max * 100;

      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then(
            (value) {
              var usersCount = users!.length;
              loadMoreUsers(usersCount);
              users = <SimpleUser>[...users!, ...newUsers!];
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

  @override
  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
  }

  void clearSearch() {
    searchTec.text = "";
    users = null;
  }

  @override
  Future getUsers() async {
    var searchQuery = state.nameTag;
    if (searchQuery != null) {
      if (!searchQuery.startsWith("@")) {
        searchQuery = "@$searchQuery";
      }

      if (!isLoading) {
        isLoading = true;

        if (searchQuery.isNotEmpty) {
          users =
              await api.searchUsers(nameTag: searchQuery, skip: 0, take: 10);
        } else {
          users = null;
        }

        isLoading = false;
      }
    }
  }

  @override
  void loadMoreUsers(int skip) async {
    var searchQuery = state.nameTag;
    if (searchQuery != null) {
      newUsers =
          await api.searchUsers(nameTag: state.nameTag!, skip: skip, take: 10);
    }
  }

  // void toUserProfile(String userId) {
  //   Navigator.of(context).pushNamed(TabNavigatorRoutes.userProfile,
  //       arguments: TabNavigatiorArguments(userId: userId));
  // }
}

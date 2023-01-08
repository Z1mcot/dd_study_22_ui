import 'package:dd_study_22_ui/domain/enums/user_list_type.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/users_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();
    var usersCount = viewModel.users?.length;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: viewModel.searchTec,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: viewModel.clearSearch,
                  ),
                  hintText: 'Start searching users...',
                  border: InputBorder.none),
              onChanged: (value) => Future.delayed(const Duration(seconds: 2))
                  .then((value) async => await viewModel.getUsers()),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.users == null
                  ? const Center(
                      child: Text("Time to meet new users..."),
                    )
                  : Column(
                      children: [
                        UsersList(
                          usersCount: usersCount ?? 0,
                          userListType: UserListTypeEnum.searchList,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SearchViewModel(context: context),
      child: const Search(),
    );
  }
}

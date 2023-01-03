import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();
    var usersCount = viewModel.foundUsers?.length;

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
              : viewModel.foundUsers == null
                  ? const Center(
                      child: Text("Time to meet new users..."),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, listIndex) {
                                Widget res;
                                var users = viewModel.foundUsers;
                                if (users != null) {
                                  var user = users[listIndex];
                                  res = GestureDetector(
                                    onTap: () =>
                                        viewModel.toUserProfile(user.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(children: [
                                        CircleAvatar(
                                          foregroundImage: NetworkImage(
                                              "$baseUrl${user.avatarLink}",
                                              headers: viewModel.headers),
                                        ),
                                        Column(
                                          children: [
                                            Text(user.nameTag),
                                            Text(
                                              user.name,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ]),
                                    ),
                                  );
                                } else {
                                  res = const SizedBox.shrink();
                                }
                                return res;
                              },
                              separatorBuilder: (_, __) => const Divider(),
                              itemCount: usersCount ?? 0),
                        )
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

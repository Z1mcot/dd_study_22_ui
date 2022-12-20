import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/profile/profile_view_model.dart';
import 'package:dd_study_22_ui/ui/roots/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();
    var user = viewModel.user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            user.nameTag,
            style: const TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: viewModel.logout,
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: (viewModel.headers != null)
                          ? NetworkImage(
                              "$baseUrl${user.avatarLink}",
                              headers: viewModel.headers,
                            )
                          : null,
                      radius: 50,
                    ),
                    Column(
                      children: [
                        Text("${user.postsCount}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Posts")
                      ],
                    ),
                    Column(
                      children: [
                        Text("${user.subscribersCount}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Followers")
                      ],
                    ),
                    Column(
                      children: [
                        Text("${user.subscriptionsCount}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Following")
                      ],
                    )
                  ],
                ),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                    "Contact email: ${user.email}\nBirth Date: ${user.birthDate}"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavigationBar(
            selectedIcon: NavigationIconSelection.profile),
      );
    } else {
      return const Scaffold(
        body: Text("Couldn't retrieve user info"),
      );
    }
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileViewModel(context: context),
      child: const ProfileWidget(),
    );
  }
}

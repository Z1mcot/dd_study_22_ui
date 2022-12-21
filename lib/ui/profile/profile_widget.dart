import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/profile/profile_view_model.dart';
import 'package:dd_study_22_ui/ui/roots/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();
    var user = viewModel.user;
    var dtf = DateFormat("dd.MM.yyyy HH:mm");

    var posts = viewModel.posts;
    var postWidgets = <Widget>[];
    if (posts != null) {
      posts.forEach((post) {
        postWidgets.add(Image(
            image: NetworkImage("$baseUrl${post.content.first.contentLink}",
                headers: viewModel.headers)));
      });
    }

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            user.nameTag,
            style: const TextStyle(fontSize: 20),
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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: viewModel.changePhoto,
                      child: CircleAvatar(
                        backgroundImage: (viewModel.headers != null)
                            ? NetworkImage(
                                "$baseUrl${user.avatarLink}",
                                headers: viewModel.headers,
                              )
                            : null,
                        radius: 50,
                      ),
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
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        "Contact email: ${user.email}\nBirth Date: ${dtf.format(user.birthDate)}"),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    children: postWidgets,
                  ),
                ),
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

import 'package:dd_study_22_ui/ui/widgets/user_profile/profile_post_tile.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/user_info.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/user_metrics.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<UserProfileViewModel>();
    var user = viewModel.user;
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.posts?.length;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            user.nameTag,
            style: const TextStyle(fontSize: 20),
          ),
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
                    viewModel.user!.avatarLink == null
                        ? const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.account_circle_rounded),
                          )
                        : viewModel.avatar == null
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 50,
                                foregroundImage: viewModel.avatar?.image),
                    UserMetrics(
                      postsCount: user.postsCount,
                      subscribersCount: user.subscribersCount,
                      subscriptionsCount: user.subscriptionsCount,
                    ),
                  ],
                ),
                UserInfo(
                  name: user.name,
                  email: user.email,
                  birthDate: user.birthDate,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size.fromHeight(30),
                  ),
                  child: const Text(
                    "Subscribe",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: GridView.builder(
                    controller: viewModel.gvc,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (_, gridIndex) {
                      Widget res;
                      var posts = viewModel.posts;
                      if (posts != null && itemCount! > 0) {
                        var post = posts[gridIndex];
                        res = GestureDetector(
                          onTap: () => viewModel.toPostDetail(post.id),
                          child: ProfilePostTile(
                            size: size,
                            post: post,
                            gridIndex: gridIndex,
                          ),
                        );
                      } else {
                        res = const SizedBox.shrink();
                      }
                      return res;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Text("Couldn't retrieve user info"),
      );
    }
  }

  static create(Object? arg) {
    String? userId;
    if (arg != null && arg is String) {
      userId = arg;
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          UserProfileViewModel(context: context, userId: userId),
      child: const UserProfileWidget(),
    );
  }
}

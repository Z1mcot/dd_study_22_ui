import 'package:dd_study_22_ui/domain/enums/profile_types.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/profile_post_tile.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/profile/profile_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/user_info.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/user_metrics.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final ProfileTypeEnum profileType;
  final ProfileViewModel viewModel;
  // final List<PostModel>? posts;

  const Profile({
    super.key,
    required this.profileType,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    // ProfileViewModel viewModel;

    // if (profileType == ProfileTypeEnum.selfProfile) {
    //   viewModel = context.read<SelfProfileViewModel>();
    // } else {
    //   viewModel = context.read<UserProfileViewModel>();
    // }

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
          actions: profileType == ProfileTypeEnum.selfProfile
              ? [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: (viewModel as SelfProfileViewModel).logout,
                  ),
                ]
              : null,
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
                    viewModel.getUserAvatar(),
                    UserMetrics(
                      userId: user.id,
                      postsCount: user.postsCount,
                      subscribersCount: user.subscribersCount,
                      toSubscribers: viewModel.toSubscribers,
                      subscriptionsCount: user.subscriptionsCount,
                      toSubscriptions: viewModel.toSubscriptions,
                    )
                  ],
                ),
                UserInfo(
                  name: user.name,
                  email: user.email,
                  birthDate: user.birthDate,
                ),
                ElevatedButton(
                  onPressed: viewModel.onProfileInfoButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.buttonBackgroundColor,
                    minimumSize: const Size.fromHeight(30),
                  ),
                  child: Text(
                    viewModel.buttonMsg ?? "",
                    style: TextStyle(color: viewModel.buttonTextColor),
                  ),
                ),
                const Divider(),
                if (viewModel.errMsg != null && viewModel.errMsg!.isNotEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock,
                              size: 72, color: Colors.black54),
                          Text(
                            viewModel.errMsg!,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (viewModel.errMsg == null || viewModel.errMsg!.isEmpty)
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
                              profileType: profileType,
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
}

import 'package:dd_study_22_ui/domain/enums/profile_types.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/ui/widgets/user_profile/profile/profile.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<UserProfileViewModel>();

    int postsCount = viewModel.posts?.length ?? 0;
    int subscribersCount = viewModel.user?.subscribersCount ?? 0;
    int sunscriptionsCount = viewModel.user?.subscriptionsCount ?? 0;

    return Profile(
      profileType: ProfileTypeEnum.anotherUserProfile,
      postsCount: postsCount,
      subscribersCount: subscribersCount,
      sunscriptionsCount: sunscriptionsCount,
    );
  }

  static create(Object? arg) {
    String? userId;
    if (arg != null && arg is TabNavigatiorArguments) {
      userId = arg.userId;
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          UserProfileViewModel(context: context, userId: userId),
      child: const UserProfileWidget(),
    );
  }
}

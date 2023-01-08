import 'package:dd_study_22_ui/domain/enums/profile_types.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/profile/profile.dart';
import 'package:dd_study_22_ui/ui/widgets/users_list/profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<UserProfileViewModel>();

    return Profile(
      profileType: ProfileTypeEnum.anotherUserProfile,
      viewModel: viewModel,
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

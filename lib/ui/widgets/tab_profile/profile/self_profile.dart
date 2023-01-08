import 'package:dd_study_22_ui/domain/enums/profile_types.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/common_user_profile/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfProfile extends StatelessWidget {
  const SelfProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SelfProfileViewModel>();

    return Profile(
      profileType: ProfileTypeEnum.selfProfile,
      viewModel: viewModel,
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SelfProfileViewModel(context: context),
      child: const SelfProfile(),
    );
  }
}

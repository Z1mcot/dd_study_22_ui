import 'package:dd_study_22_ui/domain/enums/profile_types.dart';
import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_search/profile/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePostTile extends StatelessWidget {
  final Size size;
  final PostModel post;
  final int gridIndex;
  final ProfileTypeEnum profileType;

  const ProfilePostTile({
    super.key,
    required this.size,
    required this.post,
    required this.gridIndex,
    required this.profileType,
  });

  @override
  Widget build(BuildContext context) {
    var profileViewModel = profileType == ProfileTypeEnum.selfProfile
        ? context.read<SelfProfileViewModel>()
        : context.read<UserProfileViewModel>();
    return GestureDetector(
      onTap: () => profileViewModel.toPostDetail(post.id),
      child: Image(
          image: NetworkImage("$baseUrl${post.content.first.contentLink}"),
          fit: BoxFit.cover),
    );
  }
}

import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/profile/self_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfProfilePostTile extends StatelessWidget {
  final Size size;
  final PostModel post;
  final int gridIndex;

  const SelfProfilePostTile({
    super.key,
    required this.size,
    required this.post,
    required this.gridIndex,
  });

  @override
  Widget build(BuildContext context) {
    var profileViewModel = context.read<SelfProfileViewModel>();
    return GestureDetector(
      onTap: () => profileViewModel.toPostDetail(post.id),
      child: Image(
          image: NetworkImage("$baseUrl${post.content.first.contentLink}"),
          fit: BoxFit.cover),
    );
  }
}

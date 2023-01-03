import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/list_post_widget/post_image.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/list_post_widget/post_info.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatelessWidget {
  final Size size;
  final PostModel post;
  final int listIndex;

  const PostWidget({
    super.key,
    required this.size,
    required this.post,
    required this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    var homeViewModel = context.read<HomeViewModel>();
    return GestureDetector(
      onTap: () => homeViewModel.toPostDetail(post.id),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: size.width + 100,
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              height: 50,
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () => homeViewModel.toUserProfile(post.author.id),
                child: Row(
                  children: [
                    CircleAvatar(
                      foregroundImage:
                          NetworkImage("$baseUrl${post.author.avatarLink}"),
                      radius: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      post.author.nameTag,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) =>
                    homeViewModel.onPageChanged(listIndex, value),
                itemCount: post.content.length,
                itemBuilder: (_, pageIndex) => Container(
                  color: Colors.amber[300],
                  child: PostImage(
                    imageUrl: "$baseUrl${post.content[pageIndex].contentLink}",
                    headers: homeViewModel.headers,
                  ),
                ),
              ),
            ),
            PostInfo(
              postContentCount: post.content.length,
              currentPostContent: homeViewModel.pager[listIndex],
              description: post.description,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "comments: ${post.comments ?? 0}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

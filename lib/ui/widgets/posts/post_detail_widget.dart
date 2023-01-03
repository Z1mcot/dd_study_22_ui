import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/post_comments.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/list_post_widget/post_image.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/list_post_widget/post_info.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailWidget extends StatelessWidget {
  final Size size;
  final PostModel post;
  final int listIndex;

  const PostDetailWidget({
    super.key,
    required this.size,
    required this.post,
    required this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    var postDetailViewModel = context.read<PostDetailViewModel>();
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 10),
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
              onTap: () => postDetailViewModel.toUserProfile(post.author.id),
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
                  postDetailViewModel.onPageChanged(listIndex, value),
              itemCount: post.content.length,
              itemBuilder: (_, pageIndex) => Container(
                color: Colors.amber[300],
                child: PostImage(
                  imageUrl: "$baseUrl${post.content[pageIndex].contentLink}",
                  headers: postDetailViewModel.headers,
                ),
              ),
            ),
          ),
          PostInfo(
            postContentCount: post.content.length,
            currentPostContent: postDetailViewModel.pager[listIndex],
            description: post.description,
          ),
          const CommentWidget(),
        ],
      ),
    );
  }
}

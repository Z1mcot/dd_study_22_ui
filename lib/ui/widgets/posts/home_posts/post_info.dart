import 'package:dd_study_22_ui/domain/enums/post_view_types.dart';
import 'package:dd_study_22_ui/ui/widgets/common/page_indicator.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/home_posts/posts_with_info.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/home/home_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostInfo extends StatelessWidget {
  final String postId;
  final int postContentCount;
  final int? currentPostContent;
  final int likes;
  final bool isLiked;
  final int comments;
  final String? description;
  final String nameTag;
  final PostViewTypeEnum postViewType;
  const PostInfo({
    super.key,
    required this.postContentCount,
    required this.currentPostContent,
    this.description,
    required this.likes,
    required this.comments,
    required this.nameTag,
    required this.postId,
    required this.isLiked,
    required this.postViewType,
  });

  @override
  Widget build(BuildContext context) {
    PostsWithInfo homeViewModel = postViewType == PostViewTypeEnum.fromHome
        ? context.read<HomeViewModel>()
        : context.read<PostDetailViewModel>();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: -5,
                    children: [
                      Text(
                        "$likes",
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          homeViewModel.onLikeClick(postId);
                        },
                        icon: isLiked
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_outlined,
                              ),
                        iconSize: 28,
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: -5,
                    children: [
                      Text(
                        "$comments",
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Исключительно ради сохранения внешнего вида
                      IconButton(
                        onPressed: () {
                          // homeViewModel.onCommentClick(postId);
                        },
                        icon: const Icon(
                          Icons.comment,
                        ),
                        iconSize: 28,
                      ),
                    ],
                  ),
                ],
              ),
              postContentCount > 1
                  ? PageIndicator(
                      count: postContentCount,
                      current: currentPostContent,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                width: 100,
              )
            ],
          ),
          if (description != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  Text(
                    nameTag,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(description!),
                ],
              ),
            )
        ],
      ),
    );
  }
}

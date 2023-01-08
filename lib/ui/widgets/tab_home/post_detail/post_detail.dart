import 'package:dd_study_22_ui/domain/enums/post_view_types.dart';
import 'package:dd_study_22_ui/domain/navigator_arguments.dart/tab_navigatior_arguments.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/home_posts/post_image.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/home_posts/post_info.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/post_detail_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PostDetailViewModel>();
    var size = MediaQuery.of(context).size;
    var post = viewModel.post;

    var comments = viewModel.comments?.length ?? 0;
    var likes = viewModel.post?.likes ?? 0;
    var isLiked = viewModel.post?.isLiked == 1 ? true : false;

    if (post != null) {
      return Scaffold(
        appBar: AppBar(),
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[200],
                collapsedHeight: 200,
                expandedHeight: 500,
                flexibleSpace: Column(
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
                        onTap: () => viewModel.toUserProfile(post.author.id),
                        child: Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: NetworkImage(
                                  "$baseUrl${post.author.avatarLink}"),
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
                            viewModel.onPageChanged(0, value),
                        itemCount: post.content.length,
                        itemBuilder: (_, pageIndex) => Container(
                          color: Colors.amber[300],
                          child: PostImage(
                            imageUrl:
                                "$baseUrl${post.content[pageIndex].contentLink}",
                            headers: viewModel.headers,
                          ),
                        ),
                      ),
                    ),
                    PostInfo(
                      postId: post.id,
                      postContentCount: post.content.length,
                      currentPostContent: viewModel.pager[0],
                      description: post.description,
                      isLiked: isLiked,
                      likes: likes,
                      comments: comments,
                      nameTag: post.author.nameTag,
                      postViewType: PostViewTypeEnum.fromPostDetails,
                    ),
                  ],
                ),
              )
            ];
          },
          body: PostDetailWidget(
            post: viewModel.post!,
            size: size,
            listIndex: 0,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static create(Object? args) {
    String? postId;
    String? userId;
    if (args != null && args is TabNavigatiorArguments) {
      if (args.postId != null) {
        postId = args.postId;
      }
      if (args.userId != null) {
        userId = args.userId;
      }
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          PostDetailViewModel(context: context, postId: postId, userId: userId),
      child: const PostDetail(),
    );
  }
}

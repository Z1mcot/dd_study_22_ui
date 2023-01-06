import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/ui/widgets/posts/post_comments.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';
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
    var innerScrollController = PrimaryScrollController.of(context);

    return SizedBox(
      // padding: const EdgeInsets.symmetric(vertical: 10),
      // height: size.height - 160,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (_, listIndex) {
                  Widget res;
                  var comments = postDetailViewModel.comments;
                  if (comments != null &&
                      comments.isNotEmpty &&
                      comments.length - 1 >= listIndex) {
                    var comment = comments[listIndex];
                    res = CommentWidget(
                      size: size,
                      comment: comment,
                      listIndex: listIndex,
                    );
                  } else {
                    res = const SizedBox.shrink();
                  }

                  return res;
                },
                separatorBuilder: (_, __) => const Divider(
                      thickness: 2,
                    ),
                itemCount: post.comments),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: size.width - 10,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                onTap: () {
                  innerScrollController?.jumpTo(10);
                },
                controller: postDetailViewModel.commentTec,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () => postDetailViewModel.addComment(post.id),
                  ),
                  hintText: "Maybe you have something to add..?",
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => postDetailViewModel.addComment(post.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

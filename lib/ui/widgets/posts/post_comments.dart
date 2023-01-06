import 'package:dd_study_22_ui/domain/models/comment/comment_model.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  final Size size;
  final CommentModel comment;
  final int listIndex;
  const CommentWidget({
    super.key,
    required this.size,
    required this.comment,
    required this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<PostDetailViewModel>();
    var dtf = DateFormat("dd.MM.yyyy HH:mm");

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () => viewModel.toUserProfile(comment.author.id),
                child: CircleAvatar(
                  foregroundImage:
                      NetworkImage("$baseUrl${comment.author.avatarLink}"),
                  radius: 20,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      GestureDetector(
                        onTap: () => viewModel.toUserProfile(comment.author.id),
                        child: Text(
                          comment.author.nameTag,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(comment.content),
                    ],
                  ),
                  Text(
                    dtf.format(comment.publishDate),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: const Icon(Icons.favorite_border_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

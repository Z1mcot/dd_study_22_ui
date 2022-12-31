import 'package:dd_study_22_ui/ui/widgets/posts/post_detail_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PostDetailViewModel>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: viewModel.post == null
          ? const CircularProgressIndicator()
          : PostDetailWidget(
              post: viewModel.post!,
              size: size,
              listIndex: 0,
            ),
    );
  }

  static create(Object? arg) {
    String? postId;
    if (arg != null && arg is String) {
      postId = arg;
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          PostDetailViewModel(context: context, postId: postId),
      child: const PostDetail(),
    );
  }
}

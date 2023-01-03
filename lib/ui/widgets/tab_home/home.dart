import 'package:dd_study_22_ui/ui/widgets/posts/list_post_widget/post.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.posts?.length;

    return Container(
      child: viewModel.posts == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.separated(
                  controller: viewModel.lvc,
                  itemBuilder: (_, listIndex) {
                    Widget res;
                    var posts = viewModel.posts;
                    if (posts != null) {
                      var post = posts[listIndex];
                      res = PostWidget(
                        size: size,
                        post: post,
                        listIndex: listIndex,
                      );
                    } else {
                      res = const SizedBox.shrink();
                    }
                    return res;
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: itemCount ?? 0,
                )),
                if (viewModel.isLoading) const LinearProgressIndicator(),
              ],
            ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel(context: context),
      child: const Home(),
    );
  }
}

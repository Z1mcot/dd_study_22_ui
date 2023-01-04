import 'package:dd_study_22_ui/ui/widgets/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_create/new_post/new_post_view_model.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_create/post_creator/post_creator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPost extends StatelessWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<NewPostViewModel>();

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(backgroundColor: Colors.black38),
      body: SafeArea(
        child: CameraWidget(
          onFile: (file) {
            viewModel.imagePaths!.add(file.path);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: IconButton(
          onPressed: () async => viewModel.imagePaths!.isNotEmpty
              ? await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PostCreator.create(viewModel.imagePaths!),
                ))
              : null,
          icon: const Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NewPostViewModel(context: context),
      child: const NewPost(),
    );
  }
}

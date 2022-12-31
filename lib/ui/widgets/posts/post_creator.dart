import 'dart:io';

import 'package:dd_study_22_ui/ui/widgets/posts/post_creator_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCreator extends StatelessWidget {
  final List<String> filePaths;
  const PostCreator({super.key, required this.filePaths});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AddPostViewModel>();
    var files = filePaths.map((e) => File(e)).toList();
    // viewModel.images = files;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new post"),
        actions: [
          IconButton(
              onPressed: () => viewModel.publishPost(files),
              icon: Icon(
                Icons.check,
                color: Colors.lightBlue[300],
              ))
        ],
      ),
      body: Column(
        children: [
          Image(
            image: FileImage(files.first),
            width: 200,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: TextField(
              controller: viewModel.descriptionTec,
              decoration: const InputDecoration(hintText: 'Enter description'),
            ),
          ),
        ],
      ),
    );
  }

  static create(List<String> filePaths) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AddPostViewModel(context: context),
      child: PostCreator(
        filePaths: filePaths,
      ),
    );
  }
}

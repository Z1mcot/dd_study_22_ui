import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/common/camera_widget.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_create/post_creator/post_creator.dart';
import 'package:flutter/material.dart';

class CreateViewModel extends ChangeNotifier {
  BuildContext context;
  CreateViewModel({
    required this.context,
  });

  List<String> imagePaths = <String>[];
  String? _lastFilePath;
  String? get lastFilePath => _lastFilePath;
  set lastFilePath(String? value) {
    _lastFilePath = value;
    notifyListeners();
  }

  Future toPostCreation() async {
    // var appViewModel = context.read<AppViewModel>();
    // appViewModel.isBottomBarVisible = false;

    await Navigator.of(AppNavigator.key.currentState!.context)
        .push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CameraWidget(
            onFile: (file) {
              lastFilePath = file.path;
              imagePaths.add(lastFilePath!);
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  if (imagePaths.isNotEmpty) {
                    await Navigator.of(newContext).push(
                      MaterialPageRoute(
                        builder: (_) => PostCreator.create(imagePaths),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // void toStoriesCreation() async {
  //   var appViewModel = context.read<AppViewModel>();
  //   appViewModel.isBottomBarVisible = false;
  //   notifyListeners();

  //   await Navigator.of(context).pushNamed(TabNavigatorRoutes.createStories);
  // }
}

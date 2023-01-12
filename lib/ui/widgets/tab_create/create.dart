import 'package:dd_study_22_ui/ui/widgets/tab_create/create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWidget extends StatelessWidget {
  const CreateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: viewModel.toPostCreation,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.post_add_rounded,
                        size: 28,
                      ),
                      Text("Add post", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     height: 200,
              //     color: Colors.grey[300],
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Icon(
              //           Icons.amp_stories_rounded,
              //           size: 28,
              //         ),
              //         Text("Add stories", style: TextStyle(fontSize: 16)),
              //         Text("В перспективе"),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreateViewModel(context: context),
      child: const CreateWidget(),
    );
  }
}

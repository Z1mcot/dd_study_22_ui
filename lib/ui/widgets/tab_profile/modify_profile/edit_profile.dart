import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile edit menu"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: viewModel.toAvatarChange,
                child: Container(
                  color: Colors.grey[300],
                  height: 100,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 28,
                      ),
                      Text("Change avatar", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: viewModel.toProfileEditing,
                child: Container(
                  color: Colors.grey[300],
                  height: 100,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      Text("Edit profile info", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: viewModel.toPasswordChange,
                child: Container(
                  color: Colors.grey[300],
                  height: 100,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.password,
                        size: 28,
                      ),
                      Text("Change password", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EditProfileViewModel(context: context),
      child: const EditProfileWidget(),
    );
  }
}

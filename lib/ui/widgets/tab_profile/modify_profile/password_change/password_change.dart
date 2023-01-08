import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/password_change/password_change_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordChangeWidget extends StatelessWidget {
  const PasswordChangeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PasswordChangeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Password change")),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: viewModel.oldPasswordTec,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your old password'),
                ),
                TextField(
                  controller: viewModel.newPasswordTec,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your new password'),
                ),
                TextField(
                  controller: viewModel.repeatPasswordTec,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Repeat your new password'),
                ),
                ElevatedButton(
                  onPressed:
                      viewModel.checkFields() ? viewModel.confirmChange : null,
                  child: const Text("Change password"),
                ),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null &&
                    viewModel.state.errorText!.isNotEmpty)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          PasswordChangeViewModel(context: context),
      child: const PasswordChangeWidget(),
    );
  }
}

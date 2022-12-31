import 'package:dd_study_22_ui/ui/widgets/roots/registration/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SignUpViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to eblogram")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: viewModel.nameTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name')),
                TextField(
                    controller: viewModel.nameTagTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your nametag')),
                TextField(
                    controller: viewModel.emailTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email')),
                TextField(
                    controller: viewModel.passwTec,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter password')),
                TextField(
                    controller: viewModel.retrypasswTec,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password again')),
                TextField(
                  controller: viewModel.dateinputTec,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Enter Date"),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now());

                    viewModel.dateinputTec.text =
                        pickedDate!.toUtc().toIso8601String();
                  },
                ),
                ElevatedButton(
                    onPressed:
                        viewModel.checkFields() ? viewModel.register : null,
                    child: const Text("Register")),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<SignUpViewModel>(
        create: (context) => SignUpViewModel(context: context),
        child: const SignUpWidget(),
      );
}

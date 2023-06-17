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
                    key: const Key('nameField'),
                    controller: viewModel.nameTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name')),
                TextField(
                    key: const Key('nametagField'),
                    controller: viewModel.nameTagTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your nametag')),
                TextField(
                    key: const Key('emailField'),
                    controller: viewModel.emailTec,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email')),
                TextField(
                    key: const Key('passField'),
                    controller: viewModel.passwTec,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter password')),
                TextField(
                    key: const Key('retryPassField'),
                    controller: viewModel.retrypasswTec,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password again')),
                TextField(
                  key: const Key('birthdateField'),
                  controller: viewModel.dateInputTec,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Enter your birth date"),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());

                    viewModel.dateInputTec.text =
                        pickedDate!.toUtc().toIso8601String();
                  },
                ),
                ElevatedButton(
                    key: const Key('registerBtn'),
                    onPressed:
                        viewModel.checkFields() ? viewModel.register : null,
                    child: const Text("Register")),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null &&
                    viewModel.state.errorText!.isNotEmpty)
                  Text(key: const Key('errorTxt'), viewModel.state.errorText!),
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

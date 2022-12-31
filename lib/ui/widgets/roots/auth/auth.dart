import 'package:dd_study_22_ui/ui/widgets/roots/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: viewModel.loginTec,
                    decoration: const InputDecoration(hintText: 'Enter login')),
                TextField(
                    controller: viewModel.passwTec,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter password')),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size.fromWidth(100)),
                          onPressed:
                              viewModel.checkFields() ? viewModel.login : null,
                          child: const Text("Login")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size.fromWidth(100)),
                          onPressed: viewModel.register,
                          child: const Text("Sign Up")),
                    ],
                  ),
                ),
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

  static Widget create() => ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(context: context),
        child: const Auth(),
      );
}

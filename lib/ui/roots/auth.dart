import 'package:dd_study_22_ui/data/auth_service.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;

  const _ViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
  });

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();

  BuildContext context;

  _ViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  _ViewModelState _state = const _ViewModelState(); // dangerous zone

  set state(_ViewModelState value) {
    _state = value;
    notifyListeners();
  }

  _ViewModelState get state => _state;

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) && (state.password?.isNotEmpty ?? false);
  }

  login() async {
    state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 3))
        .then((value) => state.copyWith(isLoading: false));

    await _authService
        .auth(state.login, state.password)
        .then((value) => AppNavigator.toLoader());
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      controller: viewModel.loginTec,
                      decoration: const InputDecoration(hintText: 'Enter login')),
                  TextField(
                      controller: viewModel.passwTec,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Enter password')),
                  ElevatedButton(
                      onPressed: viewModel.checkFields() ? viewModel.login : null,
                      child: const Text("Login")),
                  if (viewModel.state.isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Auth(),
      );
}

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/auth/auth_view_model_state.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();

  BuildContext context;

  AuthViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  AuthViewModelState _state = const AuthViewModelState();

  AuthViewModelState get state => _state;
  set state(AuthViewModelState value) {
    _state = value;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false);
  }

  void login() async {
    state.copyWith(isLoading: true);

    try {
      await _authService.auth(state.login, state.password).then((value) {
        AppNavigator.toLoader()
            .then(((value) => {state = state.copyWith(isLoading: false)}));
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "No connection to server");
    } on WrongCredentialsException {
      state = state.copyWith(errorText: "Incorrect username or password");
    } on ServerSideException {
      state = state.copyWith(
          errorText: "Problems on the side of server. Try again later...");
    }
  }

  void register() async {
    state.copyWith(isLoading: true);

    AppNavigator.toRegistration()
        .then((value) => {state.copyWith(isLoading: false)});
  }
}

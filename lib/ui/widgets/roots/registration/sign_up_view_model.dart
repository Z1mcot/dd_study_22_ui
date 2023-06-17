import 'package:dd_study_22_ui/domain/exceptions/exceptions.dart';
import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/widgets/roots/registration/sign_up_view_model_state.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var nameTagTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwTec = TextEditingController();
  var retrypasswTec = TextEditingController();
  var dateInputTec = TextEditingController();

  final passRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _api = RepositoryModule.apiRepository();

  BuildContext context;

  SignUpViewModel({required this.context}) {
    nameTec.addListener(() {
      state = state.copyWith(name: nameTec.text);
    });
    nameTagTec.addListener(() {
      state = state.copyWith(nameTag: nameTagTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
    retrypasswTec.addListener(() {
      state = state.copyWith(retryPassword: retrypasswTec.text);
    });
    dateInputTec.addListener(() {
      state = state.copyWith(
          birthDate: dateInputTec.text.isNotEmpty
              ? DateTime.parse(dateInputTec.text)
              : null);
    });
  }

  SignUpViewModelState _state = SignUpViewModelState();

  SignUpViewModelState get state => _state;
  set state(SignUpViewModelState value) {
    _state = value;
    notifyListeners();
  }

  bool checkFields() {
    return (state.name?.isNotEmpty ?? false) &&
        (state.nameTag?.isNotEmpty ?? false) &&
        (state.email?.isNotEmpty ?? false) &&
        (emailRegExp.hasMatch(state.email!)) &&
        (state.password?.isNotEmpty ?? false) &&
        (state.password!.length > 7 && state.password!.length < 33) &&
        (passRegExp.hasMatch(state.password!)) &&
        (state.retryPassword?.isNotEmpty ?? false) &&
        (state.password == state.retryPassword);
  }

  void register() async {
    state.copyWith(isLoading: true);
    var model = RegisterUserModel(
      name: state.name,
      nameTag: state.nameTag,
      email: state.email,
      password: state.password,
      retryPassword: state.retryPassword,
      birthDate: state.birthDate,
    );

    try {
      await _api.signUpUser(model).then((value) {
        Navigator.of(context).pop();
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
}

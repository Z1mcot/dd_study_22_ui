import 'package:dd_study_22_ui/data/services/auth_service.dart';
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
  var dateinputTec = TextEditingController();

  final _api = RepositoryModule.apiRepository();

  BuildContext context;

  SignUpViewModel({required this.context}) {
    nameTec.addListener(() {
      state.model = state.model.copyWith(name: nameTec.text);
    });
    nameTagTec.addListener(() {
      state.model = state.model.copyWith(nameTag: nameTagTec.text);
    });
    emailTec.addListener(() {
      state.model = state.model.copyWith(email: emailTec.text);
    });
    passwTec.addListener(() {
      state.model = state.model.copyWith(password: passwTec.text);
    });
    retrypasswTec.addListener(() {
      state.model = state.model.copyWith(retryPassword: retrypasswTec.text);
    });
    dateinputTec.addListener(() {
      state.model = state.model.copyWith(
          birthDate: dateinputTec.text.isNotEmpty
              ? DateTime.parse(dateinputTec.text)
              : null);
    });
  }

  SignUpViewModelState _state =
      SignUpViewModelState(model: RegisterUserModel());

  SignUpViewModelState get state => _state;
  set state(SignUpViewModelState value) {
    _state = value;
    notifyListeners();
  }

  bool checkFields() {
    return (state.model.name?.isNotEmpty ?? false) &&
        (state.model.nameTag?.isNotEmpty ?? false) &&
        (state.model.email?.isNotEmpty ?? false) &&
        (state.model.password?.isNotEmpty ?? false) &&
        (state.model.retryPassword?.isNotEmpty ?? false) &&
        (state.model.password == state.model.retryPassword);
  }

  void register() async {
    state.copyWith(isLoading: true);

    try {
      await _api.signUpUser(state.model).then((value) {
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

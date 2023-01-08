import 'package:dd_study_22_ui/domain/exceptions/exceptions.dart';
import 'package:dd_study_22_ui/domain/models/user/change_user_password_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/password_change/password_change_view_model_state.dart';
import 'package:flutter/cupertino.dart';

class PasswordChangeViewModel extends ChangeNotifier {
  var oldPasswordTec = TextEditingController();
  var newPasswordTec = TextEditingController();
  var repeatPasswordTec = TextEditingController();

  final _api = RepositoryModule.apiRepository();

  PasswordChangeState _state = PasswordChangeState();

  PasswordChangeState get state => _state;
  set state(PasswordChangeState value) {
    _state = value;
    notifyListeners();
  }

  BuildContext context;
  PasswordChangeViewModel({
    required this.context,
  }) {
    _asyncInit();
    oldPasswordTec.addListener(() {
      state = state.copyWith(oldPassword: oldPasswordTec.text);
    });
    newPasswordTec.addListener(() {
      state = state.copyWith(newPassword: newPasswordTec.text);
    });
    repeatPasswordTec.addListener(() {
      state = state.copyWith(confirmNewPassword: repeatPasswordTec.text);
    });
  }

  bool checkFields() {
    return (state.oldPassword?.isNotEmpty ?? false) &&
        (state.newPassword?.isNotEmpty ?? false) &&
        (state.confirmNewPassword?.isNotEmpty ?? false) &&
        (state.newPassword == state.confirmNewPassword);
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  void _asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  void confirmChange() async {
    state = state.copyWith(isLoading: true);
    var model = ChangeUserPasswordModel(
      oldPassword: state.oldPassword,
      newPassword: state.newPassword,
      confirmNewPassword: state.confirmNewPassword,
    );
    if (user != null) model = model.copyWith(id: user!.id);

    try {
      await _api.changePassword(model).then((value) {
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

import 'package:dd_study_22_ui/domain/exceptions/exceptions.dart';
import 'package:dd_study_22_ui/domain/models/user/modify_user_info_model.dart';
import 'package:dd_study_22_ui/domain/models/user/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/info_edit/info_edit_view_model_state.dart';
import 'package:flutter/material.dart';

import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';

class InfoEditViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var nameTagTec = TextEditingController();
  var emailTec = TextEditingController();
  var dateInputTec = TextEditingController();

  final _api = RepositoryModule.apiRepository();

  BuildContext context;

  InfoEditState _state = InfoEditState();

  InfoEditState get state => _state;
  set state(InfoEditState value) {
    _state = value;
    notifyListeners();
  }

  InfoEditViewModel({
    required this.context,
  }) {
    _asyncInit();
    nameTec.addListener(() {
      state = state.copyWith(name: nameTec.text);
    });
    nameTagTec.addListener(() {
      state = state.copyWith(nameTag: nameTagTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    dateInputTec.addListener(() {
      state = state.copyWith(
          birthDate: dateInputTec.text.isNotEmpty
              ? DateTime.parse(dateInputTec.text)
              : null);
    });
  }

  bool checkFields() {
    return (state.name?.isNotEmpty ?? false) ||
        (state.nameTag?.isNotEmpty ?? false) ||
        (state.email?.isNotEmpty ?? false) ||
        (state.birthDate != null);
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
    var model = ModifyUserInfoModel(
      name: state.name,
      nameTag: state.nameTag,
      email: state.email,
      birthDate: state.birthDate,
    );
    if (user != null) model = model.copyWith(id: user!.id);

    try {
      await _api.modifyUserInfo(model).then((value) {
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

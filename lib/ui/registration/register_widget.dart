import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/domain/models/user/register_user_model.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';

class _ViewModelState {
  RegisterUserModel model;
  final bool isLoading;
  final String? errorText;

  _ViewModelState({
    required this.model,
    this.isLoading = false,
    this.errorText,
  });

  _ViewModelState copyWith({
    RegisterUserModel? model,
    bool? isLoading,
    String? errorText,
  }) {
    return _ViewModelState(
      model: model ?? this.model,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var nameTagTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwTec = TextEditingController();
  var retrypasswTec = TextEditingController();
  var dateinputTec = TextEditingController();

  final _api = RepositoryModule.apiRepository();

  BuildContext context;

  _ViewModel({required this.context}) {
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
      state.model =
          state.model.copyWith(birthDate: DateTime.parse(dateinputTec.text));
    });
  }

  _ViewModelState _state = _ViewModelState(model: RegisterUserModel());

  _ViewModelState get state => _state;
  set state(_ViewModelState value) {
    _state = value;
    notifyListeners();
  }

  bool checkFields() {
    return (state.model.name?.isNotEmpty ?? false) &&
        (state.model.nameTag?.isNotEmpty ?? false) &&
        (state.model.email?.isNotEmpty ?? false) &&
        (state.model.password?.isNotEmpty ?? false) &&
        (state.model.retryPassword?.isNotEmpty ?? false);
  }

  void register() async {
    state.copyWith(isLoading: true);

    try {
      await _api.registerUser(state.model).then((value) {
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

class RegistrationWidget extends StatelessWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

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

  static Widget create(BuildContext bc) => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: bc),
        child: const RegistrationWidget(),
      );
}

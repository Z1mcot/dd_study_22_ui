import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';

class SignUpViewModelState {
  RegisterUserModel model;
  final bool isLoading;
  final String? errorText;

  SignUpViewModelState({
    required this.model,
    this.isLoading = false,
    this.errorText,
  });

  SignUpViewModelState copyWith({
    RegisterUserModel? model,
    bool? isLoading,
    String? errorText,
  }) {
    return SignUpViewModelState(
      model: model ?? this.model,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

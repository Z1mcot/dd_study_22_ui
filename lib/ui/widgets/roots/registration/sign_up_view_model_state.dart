class SignUpViewModelState {
  final String? name;
  final String? nameTag;
  final String? email;
  final String? password;
  final String? retryPassword;
  final DateTime? birthDate;
  final bool isLoading;
  final String? errorText;

  SignUpViewModelState({
    this.name,
    this.nameTag,
    this.email,
    this.password,
    this.retryPassword,
    this.birthDate,
    this.isLoading = false,
    this.errorText,
  });

  SignUpViewModelState copyWith({
    String? name,
    String? nameTag,
    String? email,
    String? password,
    String? retryPassword,
    DateTime? birthDate,
    bool? isLoading,
    String? errorText,
  }) {
    return SignUpViewModelState(
      name: name ?? this.name,
      nameTag: nameTag ?? this.nameTag,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
      birthDate: birthDate ?? this.birthDate,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

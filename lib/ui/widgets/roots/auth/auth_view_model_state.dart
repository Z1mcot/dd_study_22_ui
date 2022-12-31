class AuthViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;

  const AuthViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
    this.errorText,
  });

  AuthViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return AuthViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

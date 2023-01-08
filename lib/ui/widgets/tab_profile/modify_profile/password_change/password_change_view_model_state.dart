class PasswordChangeState {
  final String? oldPassword;
  final String? newPassword;
  final String? confirmNewPassword;
  final bool isLoading;
  final String? errorText;

  PasswordChangeState({
    this.oldPassword,
    this.newPassword,
    this.confirmNewPassword,
    this.isLoading = false,
    this.errorText,
  });

  PasswordChangeState copyWith({
    String? oldPassword,
    String? newPassword,
    String? confirmNewPassword,
    bool? isLoading,
    String? errorText,
  }) {
    return PasswordChangeState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

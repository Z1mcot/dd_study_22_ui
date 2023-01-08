class InfoEditState {
  final String? nameTag;
  final String? name;
  final String? email;
  final DateTime? birthDate;

  final bool isLoading;
  final String? errorText;
  InfoEditState({
    this.name,
    this.nameTag,
    this.email,
    this.birthDate,
    this.isLoading = false,
    this.errorText,
  });

  InfoEditState copyWith({
    String? nameTag,
    String? name,
    String? email,
    DateTime? birthDate,
    bool? isLoading,
    String? errorText,
  }) {
    return InfoEditState(
      nameTag: nameTag ?? this.nameTag,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

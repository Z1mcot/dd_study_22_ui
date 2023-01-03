class SearchViewModelState {
  final String? nameTag;

  SearchViewModelState({this.nameTag});

  SearchViewModelState copyWith({
    String? nameTag,
  }) {
    return SearchViewModelState(
      nameTag: nameTag ?? this.nameTag,
    );
  }
}

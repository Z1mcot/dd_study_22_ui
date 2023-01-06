class PostDetailViewModelState {
  final String? commentContent;
  PostDetailViewModelState({
    this.commentContent,
  });

  PostDetailViewModelState copyWith({
    String? commentContent,
  }) {
    return PostDetailViewModelState(
      commentContent: commentContent ?? this.commentContent,
    );
  }
}

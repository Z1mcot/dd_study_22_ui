import 'package:json_annotation/json_annotation.dart';
import 'package:dd_study_22_ui/domain/db_model.dart';

part 'post_comment.g.dart';

@JsonSerializable()
class PostComment implements DbModel {
  @override
  final String id;
  final String? authorId;
  final String? postId;
  final String content;
  final int likes;
  final int isLiked;
  final DateTime publishDate;

  PostComment({
    required this.id,
    this.authorId,
    this.postId,
    required this.content,
    required this.likes,
    required this.isLiked,
    required this.publishDate,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentToJson(this);

  factory PostComment.fromMap(Map<String, dynamic> map) =>
      _$PostCommentFromJson(map);
  @override
  Map<String, dynamic> toMap() {
    return _$PostCommentToJson(this);
  }

  PostComment copyWith({
    String? id,
    String? authorId,
    String? postId,
    String? content,
    int? likes,
    int? isLiked,
    DateTime? publishDate,
  }) {
    return PostComment(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      publishDate: publishDate ?? this.publishDate,
    );
  }
}

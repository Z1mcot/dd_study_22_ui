import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_comment.g.dart';

@JsonSerializable()
class PostComment implements DbModel {
  @override
  final String id;
  final SimpleUser author;
  final String content;
  final int likes;
  final bool isLiked;
  final String publishDate;

  PostComment({
    required this.id,
    required this.author,
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
    SimpleUser? author,
    String? content,
    int? likes,
    bool? isLiked,
    String? publishDate,
  }) {
    return PostComment(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      publishDate: publishDate ?? this.publishDate,
    );
  }
}

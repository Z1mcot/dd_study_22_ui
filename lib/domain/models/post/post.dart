import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/db_model.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String description;
  final String? authorId;
  final DateTime publishDate;
  final int likes;
  final int comments;
  final int isModified;
  final int isLiked;
  Post({
    required this.id,
    required this.description,
    this.authorId,
    required this.publishDate,
    required this.likes,
    required this.comments,
    required this.isModified,
    required this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);
  @override
  Map<String, dynamic> toMap() {
    return _$PostToJson(this);
  }

  Post copyWith({
    String? id,
    String? description,
    String? authorId,
    DateTime? publishDate,
    int? likes,
    int? comments,
    int? isModified,
    int? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      publishDate: publishDate ?? this.publishDate,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isModified: isModified ?? this.isModified,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/db_model.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String description;
  final String? authorId;
  final String publishDate;
  Post({
    required this.id,
    required this.description,
    this.authorId,
    required this.publishDate,
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
    String? publishDate,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      publishDate: publishDate ?? this.publishDate,
    );
  }
}

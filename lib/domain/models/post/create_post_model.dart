// Generated by https://quicktype.io

import 'package:dd_study_22_ui/domain/models/attachment/attach_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  final List<AttachMeta> content;
  final String? description;
  final String authorId;

  CreatePostModel({
    required this.content,
    this.description,
    required this.authorId,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);
}

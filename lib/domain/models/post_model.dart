import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String? description;
  final User author;
  final List<PostContent> content;
  final int? likes;
  final int? comments;
  final String publishDate;
  final bool? isModified;
  final bool? isLiked;

  PostModel({
    required this.id,
    this.description,
    required this.author,
    required this.content,
    this.likes,
    this.comments,
    required this.publishDate,
    this.isModified,
    this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

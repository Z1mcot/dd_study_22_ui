import 'package:dd_study_22_ui/domain/models/post/post_content.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String? description;
  final SimpleUser author;
  final List<PostContent> content;
  final int likes;
  final int comments;
  final DateTime publishDate;
  final int isModified;
  final int isLiked;

  PostModel({
    required this.id,
    this.description,
    required this.author,
    required this.content,
    required this.likes,
    required this.comments,
    required this.publishDate,
    required this.isModified,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/models/post/post_model.dart';
import 'package:dd_study_22_ui/domain/models/simple_user/simple_user.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final SimpleUser sender;
  final String description;
  final DateTime notifyDate;
  final String? postId; // С этим приходит
  final PostModel? post; // это подтягиваем из бд

  NotificationModel(
      {required this.id,
      required this.sender,
      required this.description,
      required this.notifyDate,
      this.postId,
      this.post});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    SimpleUser? sender,
    String? description,
    DateTime? notifyDate,
    String? postId,
    PostModel? post,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      description: description ?? this.description,
      notifyDate: notifyDate ?? this.notifyDate,
      postId: postId ?? this.postId,
      post: post ?? this.post,
    );
  }
}

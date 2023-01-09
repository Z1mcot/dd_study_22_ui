import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/db_model.dart';

part 'notification_db.g.dart';

@JsonSerializable()
class NotificationDb implements DbModel {
  @override
  final String id;
  final String? senderId;
  final String description;
  final DateTime notifyDate;
  final String? postId;

  NotificationDb({
    required this.id,
    required this.senderId,
    required this.description,
    required this.notifyDate,
    this.postId,
  });

  factory NotificationDb.fromJson(Map<String, dynamic> json) =>
      _$NotificationDbFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDbToJson(this);

  factory NotificationDb.fromMap(Map<String, dynamic> map) =>
      _$NotificationDbFromJson(map);
  @override
  Map<String, dynamic> toMap() {
    return _$NotificationDbToJson(this);
  }

  NotificationDb copyWith({
    String? id,
    String? senderId,
    String? description,
    DateTime? notifyDate,
    String? postId,
  }) {
    return NotificationDb(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      description: description ?? this.description,
      notifyDate: notifyDate ?? this.notifyDate,
      postId: postId ?? this.postId,
    );
  }
}

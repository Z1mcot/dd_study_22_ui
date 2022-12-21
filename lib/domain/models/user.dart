import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/db_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel {
  @override
  final String id;
  final String nameTag;
  final String name;
  final String? avatarLink;
  final String email;
  final DateTime birthDate;
  final int subscriptionsCount;
  final int subscribersCount;
  final int postsCount;

  User({
    required this.id,
    required this.nameTag,
    required this.name,
    this.avatarLink,
    required this.email,
    required this.birthDate,
    required this.subscriptionsCount,
    required this.subscribersCount,
    required this.postsCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);
  @override
  Map<String, dynamic> toMap() {
    return _$UserToJson(this);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.nameTag == nameTag &&
        other.name == name &&
        other.avatarLink == avatarLink &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.subscriptionsCount == subscriptionsCount &&
        other.subscribersCount == subscribersCount &&
        other.postsCount == postsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameTag.hashCode ^
        name.hashCode ^
        avatarLink.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        subscriptionsCount.hashCode ^
        subscribersCount.hashCode ^
        postsCount.hashCode;
  }
}

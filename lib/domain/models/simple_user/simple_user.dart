import 'package:json_annotation/json_annotation.dart';

import 'package:dd_study_22_ui/domain/db_model.dart';

part 'simple_user.g.dart';

@JsonSerializable()
class SimpleUser implements DbModel {
  @override
  final String id;
  final String nameTag;
  final String name;
  final String? avatarLink;

  SimpleUser({
    required this.id,
    required this.nameTag,
    required this.name,
    this.avatarLink,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) =>
      _$SimpleUserFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleUserToJson(this);

  factory SimpleUser.fromMap(Map<String, dynamic> map) =>
      _$SimpleUserFromJson(map);
  @override
  Map<String, dynamic> toMap() {
    return _$SimpleUserToJson(this);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimpleUser &&
        other.id == id &&
        other.nameTag == nameTag &&
        other.name == name &&
        other.avatarLink == avatarLink;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nameTag.hashCode ^ name.hashCode ^ avatarLink.hashCode;
  }
}

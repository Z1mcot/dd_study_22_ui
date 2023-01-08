import 'package:json_annotation/json_annotation.dart';

part 'modify_user_info_model.g.dart';

@JsonSerializable()
class ModifyUserInfoModel {
  final String? id;
  final String? nameTag;
  final String? name;
  final String? email;
  final DateTime? birthDate;

  ModifyUserInfoModel({
    this.id,
    this.nameTag,
    this.name,
    this.email,
    this.birthDate,
  });

  factory ModifyUserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModifyUserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModifyUserInfoModelToJson(this);

  ModifyUserInfoModel copyWith({
    String? id,
    String? nameTag,
    String? name,
    String? email,
    DateTime? birthDate,
  }) {
    return ModifyUserInfoModel(
      id: id ?? this.id,
      nameTag: nameTag ?? this.nameTag,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'sign_up_user_model.g.dart';

@JsonSerializable()
class RegisterUserModel {
  final String? name;
  final String? nameTag;
  final String? email;
  final String? password;
  final String? retryPassword;
  final DateTime? birthDate;

  RegisterUserModel({
    this.name,
    this.nameTag,
    this.email,
    this.password,
    this.retryPassword,
    this.birthDate,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserModelToJson(this);

  RegisterUserModel copyWith({
    String? name,
    String? nameTag,
    String? email,
    String? password,
    String? retryPassword,
    DateTime? birthDate,
  }) {
    return RegisterUserModel(
      name: name ?? this.name,
      nameTag: nameTag ?? this.nameTag,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}

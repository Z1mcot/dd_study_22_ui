import 'package:json_annotation/json_annotation.dart';

part 'user_session.g.dart';

@JsonSerializable()
class UserSession {
  final String refreshToken;
  String? ipAddress;
  DateTime created;

  UserSession({
    required this.refreshToken,
    this.ipAddress,
    required this.created,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String nameTag;
  final String name;
  final String? avatarLink;
  final String email;
  final String birthDate;
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
}

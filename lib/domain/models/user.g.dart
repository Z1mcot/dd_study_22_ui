// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      nameTag: json['nameTag'] as String,
      name: json['name'] as String,
      avatarLink: json['avatarLink'] as String?,
      email: json['email'] as String,
      birthDate: json['birthDate'] as String,
      subscriptionsCount: json['subscriptionsCount'] as int,
      subscribersCount: json['subscribersCount'] as int,
      postsCount: json['postsCount'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nameTag': instance.nameTag,
      'name': instance.name,
      'avatarLink': instance.avatarLink,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'subscriptionsCount': instance.subscriptionsCount,
      'subscribersCount': instance.subscribersCount,
      'postsCount': instance.postsCount,
    };

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
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nameTag': instance.nameTag,
      'name': instance.name,
      'avatarLink': instance.avatarLink,
    };

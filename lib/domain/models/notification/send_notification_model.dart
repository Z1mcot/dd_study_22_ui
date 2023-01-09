import 'package:json_annotation/json_annotation.dart';

part 'send_notification_model.g.dart';

@JsonSerializable()
class SendNotificationModel {
  final String userId;
  final Push push;

  SendNotificationModel({
    required this.userId,
    required this.push,
  });

  factory SendNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$SendNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendNotificationModelToJson(this);
}

@JsonSerializable()
class Push {
  final int? badge;
  final String? sound;
  final Alert? alert;
  final CustomData? customData;

  Push({
    this.badge,
    this.sound,
    this.alert,
    this.customData,
  });

  factory Push.fromJson(Map<String, dynamic> json) => _$PushFromJson(json);

  Map<String, dynamic> toJson() => _$PushToJson(this);
}

@JsonSerializable()
class Alert {
  final String? title;
  final String? subtitle;
  final String? body;

  Alert({
    this.title,
    this.subtitle,
    this.body,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}

@JsonSerializable()
class CustomData {
  final String? additionalProp1;
  final String? additionalProp2;
  final String? additionalProp3;

  CustomData({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory CustomData.fromJson(Map<String, dynamic> json) =>
      _$CustomDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomDataToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'subscribe_model.g.dart';

@JsonSerializable()
class SubscribeModel {
  String? subscriberId;
  final String authorId;

  SubscribeModel({
    this.subscriberId,
    required this.authorId,
  });

  factory SubscribeModel.fromJson(Map<String, dynamic> json) =>
      _$SubscribeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeModelToJson(this);
}

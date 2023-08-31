import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

class AppConfig {
  AppConfig._() {
    _init();
  }
  static final AppConfig _instance = AppConfig._();
  factory AppConfig() => _instance;

  static late _AppConfig _cfg;
  static String get baseUrl => _cfg.baseUrl;
  static FirebaseOptions get firebaseOptions => _cfg.firebaseOptions;

  static bool isInitialized = false;

  static const String _kConfig = String.fromEnvironment('config');

  Future _init() async {
    if (isInitialized) {
      return;
    }

    if (_kConfig.isNotEmpty) {
      var cfgFileName = _kConfig;
      var cfgPath = 'assets/secrets/$cfgFileName.json';
      var cfgString = await rootBundle.loadString(cfgPath);
      var map = jsonDecode(cfgString);
      _cfg = _AppConfig.fromJson(map);
      isInitialized = true;
    }
  }
}

@JsonSerializable()
class _AppConfig {
  final String baseUrl;

  @FirebaseOptionsJsonConverter()
  final FirebaseOptions firebaseOptions;

  _AppConfig({
    required this.baseUrl,
    required this.firebaseOptions,
  });

  factory _AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

class FirebaseOptionsJsonConverter
    extends JsonConverter<FirebaseOptions, Map<String, dynamic>> {
  const FirebaseOptionsJsonConverter();

  @override
  FirebaseOptions fromJson(Map<String, dynamic> json) => FirebaseOptions(
        apiKey: json['apiKey'],
        appId: json['appId'],
        messagingSenderId: json['messagingSenderId'],
        projectId: json['projectId'],
        storageBucket: json['storageBucket'],
      );

  @override
  Map<String, dynamic> toJson(FirebaseOptions object) => <String, dynamic>{
        'apiKey': object.apiKey,
        'appId': object.appId,
        'messagingSenderId': object.messagingSenderId,
        'projectId': object.projectId,
        'storageBucket': object.storageBucket,
      };
}

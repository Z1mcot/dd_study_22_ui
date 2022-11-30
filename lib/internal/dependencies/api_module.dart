import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dio/dio.dart';

String baseUrl = "10.0.2.2:5050/";

class ApiModule {
  static AuthClient? _authClient;

  static AuthClient auth() {
    if (_authClient == null) {
      final dio = Dio();
      _authClient = AuthClient(dio, baseUrl: baseUrl);
    }
    return _authClient!;
  }
}

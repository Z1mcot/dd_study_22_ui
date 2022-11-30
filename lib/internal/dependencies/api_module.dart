import 'package:dd_study_22_ui/data/clients/auth_client.dart';
import 'package:dio/dio.dart';

String baseUrl = "localhost:5001/";

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

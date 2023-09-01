import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/domain/models/token/refresh_token_request.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dio/dio.dart';

import '../../data/clients/api_client.dart';
import '../../data/clients/auth_client.dart';
import '../config/app_config.dart';

class ApiModule {
  static AuthClient? _authClient;
  static ApiClient? _apiClient;

  static AuthClient auth() =>
      _authClient ??
      AuthClient(
        Dio(),
        baseUrl: AppConfig.baseUrl,
      );
  static ApiClient api() =>
      _apiClient ??
      ApiClient(
        _addIntercepters(Dio()),
        baseUrl: AppConfig.baseUrl,
      );

  static Dio _addIntercepters(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _requestTokenInterceptor,
        onError: _errorInterceptor,
      ),
    );

    return dio;
  }

  static void _requestTokenInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    options.headers.addAll({"Authorization": "Bearer $token"});
    return handler.next(options);
  }

  static void _errorInterceptor(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      RequestOptions options = error.response!.requestOptions;

      var refreshToken = await TokenStorage.getRefreshToken();
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      try {
        var token = await auth().refreshToken(request);
        await TokenStorage.setStoredToken(token);
        options.headers["Authorization"] = "Bearer ${token!.accessToken}";
      } catch (e) {
        var service = AuthService();
        if (await service.checkAuth()) {
          await service.cleanToken();
          AppNavigator.toLoader();
        }

        return handler.resolve(
          Response(statusCode: 400, requestOptions: options),
        );
      }

      Dio fetchDio = Dio();

      return handler.resolve(await fetchDio.fetch(options));
    } else {
      return handler.next(error);
    }
  }
}

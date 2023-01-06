import 'package:dd_study_22_ui/domain/models/token/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/token/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user/sign_up_user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST("/api/Auth/GenerateToken")
  Future<TokenResponse?> getToken(@Body() TokenRequest body);

  @POST("/api/Auth/RenewToken")
  Future<TokenResponse?> refreshToken(@Body() RefreshTokenRequest body);

  @POST("/api/Auth/RegisterUser")
  Future signUpUser(@Body() RegisterUserModel body);
}

import 'package:dd_study_22_ui/domain/models/post.dart';
import 'package:dd_study_22_ui/domain/models/refresh_token_request.dart';
import 'package:dd_study_22_ui/domain/models/token_request.dart';
import 'package:dd_study_22_ui/domain/models/token_response.dart';
import 'package:dd_study_22_ui/domain/models/user/register_user_model.dart';
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
  Future registerUser(@Body() RegisterUserModel body);
}

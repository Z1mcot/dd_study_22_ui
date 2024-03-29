import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/domain/exceptions/exceptions.dart';
import 'package:dd_study_22_ui/domain/models/token/push_token.dart';
import 'package:dd_study_22_ui/domain/repository/api_repository.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/config/token_storage.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/internal/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();
  final DataService _dataService = DataService();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var ip = await Ipify.ipv4();
        var token =
            await _api.getToken(login: login, password: password, ip: ip);
        if (token != null) {
          await TokenStorage.setStoredToken(token);

          var user = await _api.getUser();
          if (user != null) {
            SharedPrefs.setStoredUser(user);
          }
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401].contains(e.response?.statusCode)) {
          throw WrongCredentialsException();
        } else if (<int>[500].contains(e.response?.statusCode)) {
          throw ServerSideException();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    var res = false;

    if (await TokenStorage.getAccessToken() != null) {
      var user = await _api.getUser();

      if (user != null) {
        var token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await _api.subscribeToNotifications(PushToken(token: token));
        }

        await SharedPrefs.setStoredUser(user);
        await _dataService.createUpdateUser(user);
      }

      res = true;
    }

    return res;
  }

  Future cleanToken() async {
    await TokenStorage.setStoredToken(null);
  }

  Future logout() async {
    try {
      await _api.unsubscribeFromNotifications();
    } on Exception catch (e, _) {
      e.toString().console();
    }
    await cleanToken();
  }
}

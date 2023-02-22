import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/http_interceptiors.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // TODO: Modulariza o endpoint
  static const String url = "http://192.168.0.10:3000/";
  static const String resource = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}login"),
        body: {'email': email, 'password': password});
    if (response.statusCode != 200) {
      String content = jsonDecode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  register({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}register"),
        body: {'email': email, 'password': password});
    if (response.statusCode != 201) {
      String content = jsonDecode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = jsonDecode(body);
    String token = map["accesstoken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("accessToken", token);
    shared.setString("email", email);
    shared.setInt("id", id);
  }
}

class UserNotFindException implements Exception {}

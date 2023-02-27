import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String url = WebClient.url;
  http.Client client = WebClient().client;
  static const String resource = "journals/";

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}login"),
        body: {'email': email, 'password': password});
    if (response.statusCode == 400 &&
        json.decode(response.body) == "Cannot find user") {
      throw UserNotFoundException();
    }
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}register"),
        body: {'email': email, 'password': password});
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = jsonDecode(body);
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("accessToken", token);
    shared.setString("email", email);
    shared.setInt("id", id);
  }
}

class UserNotFoundException implements Exception {}

class UserAlreadyExists implements Exception {}

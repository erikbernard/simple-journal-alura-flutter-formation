import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;

class JournalService {
  String url = WebClient.url;
  http.Client client = WebClient().client;
  static const String resource = "journals/";

  String getURL() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = jsonEncode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getURL()),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidExeption();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidExeption();
      }
      throw HttpException(response.body);
    }
    List<Journal> list = [];
    List<dynamic> listDynamic = jsonDecode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = jsonEncode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getURL()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );
    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidExeption();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
      Uri.parse("${getURL()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidExeption();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class TokenNotValidExeption implements Exception {}

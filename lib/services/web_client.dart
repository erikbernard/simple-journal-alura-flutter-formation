import 'package:flutter_webapi_first_course/services/http_interceptiors.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;

class WebClient {
  static const String url = "http://192.168.0.10:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(seconds: 5),
  );
}

import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:http/http.dart' as http;

class APIService {
  static String username = "";
  static String password = "";
  static String baseUrl = "http://192.168.0.15:5010/api/";
  String route;

  APIService({required this.route});

  void setParametar(String Username, String Password) {
    username = Username;
    password = Password;
  }

  static Future<List<dynamic>?> Get(String route, dynamic object) async {
    String queryString = Uri(queryParameters: object).query;
    String osnovniUrl = baseUrl + route;
    if (object != null) {
      osnovniUrl = osnovniUrl + '?' + queryString;
    }
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.parse(osnovniUrl),
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    }
    return null;
  }

  static Future<dynamic> GetById(String route, dynamic id) async {
    String osnovniUrl = baseUrl + route + '/' + id;
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
      Uri.parse(osnovniUrl),
      headers: <String, String>{
        "accept": "text/plain",
        HttpHeaders.authorizationHeader: basicAuth
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  static Future<dynamic> Post(String route, String body,
      [bool? isRegistracija]) async {
    String osnovniUrl = baseUrl + route;
    late String basicAuth;
    if (isRegistracija != null) {
      String tempPrivilegijeUser = "admin";
      String tempPrivilegijePass = "admin";
      basicAuth = 'Basic ' +
          base64Encode(
              utf8.encode('$tempPrivilegijeUser:$tempPrivilegijePass'));
    } else {
      basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    }
    final response = await http.post(
      Uri.parse(osnovniUrl),
      headers: <String, String>{
        "accept": "application/json",
        "content-type": "application/json",
        HttpHeaders.authorizationHeader: basicAuth
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  static Future<dynamic> Update(String route, String body, dynamic id) async {
    String osnovniUrl = baseUrl + route + '/' + id.toString();
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.put(Uri.parse(osnovniUrl),
        headers: <String, String>{
          "accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: basicAuth
        },
        body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
  }
}

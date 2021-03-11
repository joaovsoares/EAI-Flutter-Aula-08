//pubspec.yaml
//dependencies:
//http: ^0.12.2
import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAPI {
  String endpoint = 'https://api.hgbrasil.com/finance?format=json&key=80f27c39';

  Future<Map> obterDados() async {
    http.Response response = await http.get(endpoint);
    return json.decode(response.body);
  }
}
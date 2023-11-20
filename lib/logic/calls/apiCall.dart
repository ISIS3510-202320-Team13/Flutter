import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCall {
  //final String baseUrl = '172.20.10.3:8000';
  final String baseUrl = 'http://api.parkez.xyz:8082/';

  Future<Map<String, dynamic>> fetch(String endpoint) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$baseUrl$endpoint'),
          headers: {"X-API-KEY": "my_api_key"});
    } catch (e) {
      return {'error': e};
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load entity: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> create(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('$baseUrl$endpoint'),
        headers: <String, String>{
          "X-API-KEY": "my_api_key",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create entity');
    }
  }

  Future<Map<String, dynamic>> update(
      String endpoint, String uid, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$uid'),
      headers: <String, String>{
        "X-API-KEY": "my_api_key",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update entity');
    }
  }
}

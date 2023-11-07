import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCall {
  final String baseUrl = 'http://api.parkez.xyz:8082/';

  Future<Map<String,dynamic>> fetch(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      Map<String,dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load entity');
    }
  }

  Future<Map<String,dynamic>> create(String endpoint, Map<String,dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create entity');
    }
  }

  Future<Map<String,dynamic>> update(String endpoint, String uid, Map<String,dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$uid'),
      headers: <String, String>{
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


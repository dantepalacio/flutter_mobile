import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// ОБНВОЛЯТЬ USERNAME в РЕГИСТРАЦИИ
void main() {
  var token;
  test('Login', () async {
    final url = Uri.parse('http://192.168.0.8:8000/token/');
    final data = {'username': 'test123', 'password': 'anuar123'};
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    token = jsonDecode(response.body)['access'];
    print(token);
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });
  test('Registration', () async {
    final url = Uri.parse('http://192.168.0.8:8000/api/register/');
    final data = {
      'username': 'test1234567890',
      'email': 'asasa@mai.ry',
      'password': 'anuar123'
    };
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });

  test('GetListArticles', () async {
    final url = Uri.parse('http://192.168.0.8:8000/api-arcticles/');
    final response = await http.get(url);
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });

  test('FetchLikes', () async {
    final url = Uri.parse('http://192.168.0.8:8000/api-like/');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });
}

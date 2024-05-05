import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String parseServerUrl = 'https://parseapi.back4app.com';
  static const String applicationId = '5vXrHKZdEuWgjUXybjx96svTDGDXf1839QpZtKt0';
  static const String restApiKey = 'c4vdvwqXh34VeCHLq0M1W2un004Zf1ZXoqTkZWWs';
  static const String clientKey = 'Y68L9vISTrsYsMmCmDCZ2DDcXUWfJicxkK4IZVLW';

  Future<Map<String, dynamic>> signUp(String username, String password, String email, String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse('$parseServerUrl/users'),
      headers: <String, String>{
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'X-Parse-Client-Key': clientKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'email': email,
        'firstName':firstName,
        'lastName':lastName
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('$parseServerUrl/login?username=$username&password=$password'),
      headers: <String, String>{
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'X-Parse-Client-Key': clientKey,
      },
    );
    return jsonDecode(response.body);
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:ai_expense/utils/local_storage.dart'; // 1. ADD THIS IMPORT
import 'package:http/http.dart' as http;

class AuthRepository {
  final String loginUrl =
      'https://capestone-backend-1-q0hb.onrender.com/api/auth/login';
  final String registerUrl =
      'https://capestone-backend-1-q0hb.onrender.com/api/auth/register';

  Future<List> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Login Status Code: ${response.statusCode}');
    print('Login Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['token'];
      final String name = data['user']['name'];
      final String userEmail = data['user']['email'];

      // 2. SAVE THE TOKEN AND USER'S NAME
      await LocalStorage.setString('token', token);
      await LocalStorage.setString('name', name);

      return [token, name, userEmail];
    }
    throw Exception('Invalid email or password');
  }

  Future<List> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print('Signup Status Code: ${response.statusCode}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final String token = data['token'];
      final String userName = data['user']['name'];
      final String userEmail = data['user']['email'];

      // 3. ALSO SAVE THE TOKEN ON SIGNUP
      await LocalStorage.setString('token', token);
      await LocalStorage.setString('name', userName);
      print("im here==========================");

      return [token, userName, userEmail];
    }
    throw Exception('Signup failed');
  }
}

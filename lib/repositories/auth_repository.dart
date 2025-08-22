import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


class AuthRepository {
  // Simulate network calls. Replace with real API.

  // Real endpoints (port 8000)
  final String loginUrl = 'http://localhost:8000/api/auth/login';
  final String registerUrl = 'http://localhost:8000/api/auth/register';

  //TODO: all authentication logic should be implemented here using API
  
  Future<List> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.post(Uri.parse(loginUrl),
    headers: {"Content-Type": "application/json"},
    body:jsonEncode({'email': email, 'password': password}));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return [jsonDecode(response.body)['token'], jsonDecode(response.body)['message']['name'],jsonDecode(response.body)['message']['email']];
    }
    throw Exception('Invalid email or password');

    
    // await Future.delayed(const Duration(seconds: 2));
    // // Fake validation
    // if (email == 'test@example.com' && password == 'password') {
    //   return 'fake_token_123';
    // }
    // throw Exception('Invalid email or password');
  }

  Future<List> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.post(Uri.parse(registerUrl),
    headers: {"Content-Type": "application/json"},
     body:jsonEncode({'name':name,'email': email, 'password': password}) );
     print(response.statusCode);
    if (response.statusCode == 201) {
      return [jsonDecode(response.body)['token'], jsonDecode(response.body)['message']['name'],jsonDecode(response.body)['message']['email']];
    }
    throw Exception('Signup failed');
    // await Future.delayed(const Duration(seconds: 2));
    // // In real app check duplicates
    // if (email.contains('@')) {
    //   return 'fake_signup_token_456';
    // }
    // throw Exception('Signup failed');
  }
}
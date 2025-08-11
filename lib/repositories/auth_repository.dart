import 'dart:async';

class AuthRepository {
  // Simulate network calls. Replace with real API.

  //TODO: all authentication logic should be implemented here using API
  
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // Fake validation
    if (email == 'test@example.com' && password == 'password') {
      return 'fake_token_123';
    }
    throw Exception('Invalid email or password');
  }

  Future<String> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // In real app check duplicates
    if (email.contains('@')) {
      return 'fake_signup_token_456';
    }
    throw Exception('Signup failed');
  }
}
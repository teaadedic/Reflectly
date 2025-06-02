import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000'; // Localhost for Android emulator

  Future<bool> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'UserName': userName,
        'Password': password,
      }),
    );

    print('Login status code: ${response.statusCode}');
    print('Login response body: ${response.body}');

    return response.statusCode == 200;
  }

  Future<bool> register(String fullName, String userName, String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Name': fullName,
        'UserName': userName,
        'Email': email,
        'Password': password,
        'PasswordConfirmation': passwordConfirmation, // Assuming password confirmation is the same
      }),
    );

    print('Register status code: ${response.statusCode}');
    print('Register response body: ${response.body}');

    return response.statusCode == 200;
  }
}

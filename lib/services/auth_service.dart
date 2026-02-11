import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_app/models/api_response.dart';
import 'package:to_do_app/models/auth_response.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8080/api/auth';
  Future<ApiResponse<AuthResponse>> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final apiResponse = jsonDecode(response.body) as Map<String, dynamic>;

      return ApiResponse.fromJson(
        apiResponse,
        (data) => AuthResponse.fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw Exception('Failed to login');
    }
  }
}

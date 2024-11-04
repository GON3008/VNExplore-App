import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://vnexplore.test/api/auth';

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      print('Email không hợp lệ');
      return false;
    }

    if (password.length < 8) {
      print('Mật khẩu phải có ít nhất 8 ký tự');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String? jwtToken = data['data']['jwt_token'];
      if (jwtToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jwtToken);
      }
      return true;
    } else {
      final data = jsonDecode(response.body);
      print('Đăng nhập thất bại: ${data['message']}');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    // Kiểm tra độ dài mật khẩu và định dạng email
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      print('Email không hợp lệ');
      return false;
    }

    if (password.length < 8) {
      print('Mật khẩu phải có ít nhất 8 ký tự');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 201) {
      print('Đăng ký thành công');
      return true;
    } else {
      final data = jsonDecode(response.body);
      print('Đăng ký thất bại: ${data['errors']}');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

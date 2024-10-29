import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://vnexplore.test/api/auth'; // Đổi URL này nếu cần

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Lấy token từ shared preferences
  }

  Future<bool> login(String email, String password) async {
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
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Khai báo biến data ở đây

      // Lưu token vào SharedPreferences
      String? jwtToken = data['data']['jwt_token'];
      if (jwtToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jwtToken);
      }

      return true;
    } else {
      final data = jsonDecode(response.body); // Đưa lại khai báo biến data ở đây
      // Xử lý lỗi trả về từ server
      print('Đăng nhập thất bại: ${data['message']}');
      return false; // Đăng nhập thất bại
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Xóa token
  }
}

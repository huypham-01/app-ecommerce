import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop/constants.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  int _userId = 0;

  // Getter for token
  String get token => _token;
  int get userId => _userId;

  // Hàm đăng nhập
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token']; // Lưu token
      _userId = data['user']['id']; // Lưu token
    
      notifyListeners(); // Thông báo cho các widget sử dụng Provider

      return true;
    } else {
      return false;
    }
  }

  // Lấy token
  Future<String> getToken() async {
    return _token;
  }

  Future<int> getUserId() async {
    return _userId;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      return false; // Không có token để đăng xuất
    }

    // Gửi yêu cầu đăng xuất lên API
    final response = await http.post(
      Uri.parse(ApiConstants.logoutUrl),
      headers: {
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      // Xóa token trong SharedPreferences sau khi đăng xuất thành công
      await prefs.remove('token');
      await prefs.remove('user_id'); // Nếu bạn lưu ID người dùng
      _token = '';
       // Xóa token khỏi ứng dụng
      notifyListeners(); // Cập nhật lại UI

      return true;
    } else {
      return false; // Đăng xuất thất bại
    }
  }
  
}

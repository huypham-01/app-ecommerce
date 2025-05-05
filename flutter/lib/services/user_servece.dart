import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shop/constants.dart';
import 'package:shop/models/profile_cart_model.dart';

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id'); // Trả về user_id hoặc null
}

Future<String?> gettoken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // Trả về user_id hoặc null
}

class UserService {
  final String apiUrl = ApiConstants.baseUrl; // Địa chỉ API của bạn

  // Hàm lấy dữ liệu người dùng từ API bằng token
  Future<User> fetchUserDetail() async {
    final userId = await getUserId();
    final response = await http.get(Uri.parse('$apiUrl/profile/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }
}

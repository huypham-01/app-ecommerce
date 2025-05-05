import 'package:flutter/material.dart';
import 'package:shop/models/profile_cart_model.dart';
import 'package:shop/services/user_servece.dart';


class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  bool _isLoading = false;
  User? _user;

  bool get isLoading => _isLoading;
  User? get user => _user;

  // Hàm gọi service để lấy thông tin người dùng
  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.fetchUserDetail();
    } catch (error) {
      // Xử lý lỗi nếu cần
      print('Error fetching user details: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  static of(BuildContext context) {}
}

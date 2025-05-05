import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop/constants.dart';
import 'package:shop/services/user_servece.dart';

class ProductReviewService {
  final String apiUrl = ApiConstants.baseUrl; // Địa chỉ API của bạn

  Future<Map<String, dynamic>?> submitReview(
      int productId, int rating, String review) async {
    try {
      final userId = await getUserId(); // Lấy userId đã lưu

      if (userId == null) {
        print("Không tìm thấy userId trong SharedPreferences");
        return null; // Nếu không có userId, không gửi yêu cầu
      }

      // Gửi yêu cầu đánh giá với userId
      final response = await http.post(
        Uri.parse('$apiUrl/product/$productId/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId, // Gửi userId từ SharedPreferences
          'rating': rating,
          'review': review,
        }),
      );

      if (response.statusCode == 200) {
        return json
            .decode(response.body); // Trả về dữ liệu từ API nếu thành công
      } else {
        return null; // Trả về null nếu có lỗi
      }
    } catch (e) {
      print('Error submitting review: $e');
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/constants.dart';
import 'package:shop/models/order_status_model.dart';

class OrderService {
  static const String baseUrl = ApiConstants.baseUrl; // Thay URL server của bạn

  // Hàm gửi dữ liệu đơn hàng
  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/orders"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        // Đặt hàng thành công
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  // Hàm lấy danh sách đơn hàng
  Future<List<OrderItem>> fetchOrders(int? userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "$baseUrl/order/status/$userId"), // Gọi API để lấy đơn hàng của user
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Chuyển đổi danh sách đơn hàng thành đối tượng Order
        return data.map((orderData) => OrderItem.fromJson(orderData)).toList();
      } else {
        print("Error fetching orders: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> cancelOrder(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/order/$orderId/cancel'),
      );

      if (response.statusCode == 200) {
        return json
            .decode(response.body); // Trả về dữ liệu từ API nếu thành công
      } else {
        return null; // Trả về null nếu có lỗi
      }
    } catch (e) {
      print('Error canceling order: $e');
      return null; // Trả về null nếu có lỗi trong quá trình gọi API
    }
  }
  // Phương thức để đánh dấu đơn hàng là "Đã nhận được hàng"
  Future<Map<String, dynamic>?> markAsDelivered(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/order/$orderId/delivered'),
      );

      if (response.statusCode == 200) {
        return json
            .decode(response.body); // Trả về dữ liệu từ API nếu thành công
      } else {
        return null; // Trả về null nếu có lỗi
      }
    } catch (e) {
      print('Error marking order as delivered: $e');
      return null;
    }
  }

}

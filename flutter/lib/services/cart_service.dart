import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/constants.dart';
import 'package:shop/services/user_servece.dart';

import '../models/cart_model.dart';

class CartService {
  final String apiUrl = ApiConstants.cartUrl;

  // Cập nhật số lượng sản phẩm
  Future<void> updateCartItem(int cartId, int quantity) async {
    final response = await http.post(
      Uri.parse('$apiUrl/update-quantity'),
      body: {
        "cart_id": cartId.toString(),
        "quantity": quantity.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }

  Future<void> addToCart(int productId, int? userId, int quantity, double price,
      String size) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      body: {
        'product_id': productId.toString(),
        'price': price.toString(),
        'size': size,
        'quantity': quantity.toString(),
        'user_id': userId.toString(),
      },
    );
    if (response.statusCode == 200) {
      print('Thêm vào giỏ hàng thành công');
    } else {
      print('Lỗi khi thêm vào giỏ hàng');
    }
  }

  Future<List<CartItem>> fetchCartItems(int userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CartItem.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return []; // Giỏ hàng trống
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> removeCartItem(int cartId) async {
    final url = Uri.parse('$apiUrl/remove/$cartId'); // API endpoint
    final response = await http.delete(
      url,
    );

    if (response.statusCode == 200) {
      // Xóa thành công
      final data = jsonDecode(response.body);
      print('Đã xóa sản phẩm khỏi giỏ hàng: $data');
    } else {
      // Xử lý lỗi
      print('Lỗi khi xóa sản phẩm khỏi giỏ hàng: ${response.body}');
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<int> fetchCartItemCount() async {
    int? userId = await getUserId();
    final url = Uri.parse('$apiUrl/item/$userId');
    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['item_count'] != null) {
          // Đếm số lượng phần tử trong mảng `item_count`
          return (data['item_count'] as List).length;
        } else {
          throw Exception('API Error: ${data['message'] ?? "Unknown Error"}');
        }
      } else {
        throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching cart item count: $e");
      return 0; // Trả về 0 nếu xảy ra lỗi
    }
  }
}

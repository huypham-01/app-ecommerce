import 'package:flutter/material.dart';
import 'package:shop/models/order_status_model.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/services/user_servece.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;
  bool _hasError = false;

  List<OrderItem> _orders = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  List<OrderItem> get orders => _orders;

  // Hàm gọi service để gửi đơn hàng
  Future<bool> placeOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();

    final success = await _orderService.createOrder(orderData);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  // Hàm lấy tất cả các đơn hàng
  Future<void> fetchOrders() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    final int? userId = await getUserId();
    try {
      final List<OrderItem> fetchedOrders =
          await _orderService.fetchOrders(userId);
      _orders = fetchedOrders;
    } catch (error) {
      _hasError = true;
      print("Error fetching orders: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Hàm cập nhật trạng thái đơn hàng (ví dụ: chờ xác nhận, đang giao hàng, đã giao)
  // Future<void> updateOrderStatus(int orderId, String newStatus) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     await _orderService.updateOrderStatus(orderId, newStatus);
  //     // Sau khi cập nhật thành công, chúng ta sẽ tải lại danh sách đơn hàng
  //     await fetchOrders();
  //   } catch (error) {
  //     _hasError = true;
  //     print("Error updating order status: $error");
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Hàm lọc đơn hàng theo trạng thái (ví dụ: "chờ xác nhận", "đang giao", "đã giao")
  List<OrderItem> filterOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }
   // Phương thức để hủy đơn hàng
  Future<void> cancelOrder(int orderId) async {
    try {
      final response = await _orderService.cancelOrder(orderId);

      if (response != null && response['message'] == 'Đơn hàng đã được hủy thành công.') {
        // Cập nhật trạng thái đơn hàng thành cancel trong danh sách
        orders.firstWhere((order) => order.id == orderId).status = 'cancel';
        notifyListeners();  // Cập nhật UI
      } else {
        print('Không thể hủy đơn hàng');
      }
    } catch (e) {
      print('Error canceling order: $e');
    }
  }
   // Phương thức để đánh dấu đơn hàng là "Đã nhận được hàng"
  Future<void> markAsDelivered(int orderId) async {
    try {
      final response = await _orderService.markAsDelivered(orderId);

      if (response != null &&
          response['message'] == 'success') {
        // Cập nhật trạng thái đơn hàng thành "delivered"
        orders.firstWhere((order) => order.id == orderId).status = 'delivered';
        notifyListeners(); // Cập nhật UI
      } else {
        print('Không thể đánh dấu đơn hàng là đã nhận');
      }
    } catch (e) {
      print('Error marking order as delivered: $e');
    }
  }
}

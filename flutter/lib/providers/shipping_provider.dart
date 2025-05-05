import 'package:flutter/material.dart';
import '../services/shipping_service.dart';

class ShippingProvider with ChangeNotifier {
  final ShippingService _shippingService = ShippingService();

  // Danh sách phương thức vận chuyển
  List<dynamic> _shippingMethods = [];
  String _selectedShippingMethod = "";

  // Getter để truy cập từ UI
  List<dynamic> get shippingMethods => _shippingMethods;
  String get selectedShippingMethod => _selectedShippingMethod;

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Gọi service để lấy danh sách phương thức vận chuyển
  Future<void> fetchShippingMethods() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final methods = await _shippingService.fetchShippingMethods();

      // Lọc chỉ các phương thức vận chuyển có trạng thái 'active' (nếu cần)
      _shippingMethods =
          methods.where((method) => method['status'] == 'active').toList();

      // Mặc định chọn phương thức đầu tiên
      if (_shippingMethods.isNotEmpty) {
        _selectedShippingMethod = _shippingMethods[0]['id'].toString();
      }
    } catch (e) {
      _errorMessage = "Không thể tải phương thức vận chuyển. Vui lòng thử lại.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Chọn phương thức vận chuyển
  void selectShippingMethod(String methodId) {
    _selectedShippingMethod = methodId;
    notifyListeners();
  }
}

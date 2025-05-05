import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/services/user_servece.dart';

class CartProvider with ChangeNotifier {
  int _itemCount = 0; // Tổng số sản phẩm
  List<CartItem> _cartItems = []; // Danh sách sản phẩm trong giỏ hàng
  bool _isLoading = true; // Trạng thái tải dữ liệu

  final CartService _cartService = CartService();

  // Getters
  int get itemCount => _itemCount;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  CartProvider() {
    fetchCartItems(); // Gọi ngay khi khởi tạo Provider
  }
  bool get isAllSelected {
    return _cartItems.every((item) => item.isSelected);
  }

  // Fetch số lượng sản phẩm từ backend
  Future<void> fetchItemCount() async {
    try {
      _itemCount = await _cartService.fetchCartItemCount();
      notifyListeners();
    } catch (e) {
      print("Error fetching item count: $e");
    }
  }

  // Fetch danh sách sản phẩm từ backend
  Future<void> fetchCartItems() async {
    try {
      _isLoading = true;
      _cartItems = [];
      notifyListeners(); // Cập nhật trạng thái tải
      final userId = await getUserId(); // Lấy user ID từ SharedPreferences
      if (userId != null) {
        _cartItems = await _cartService.fetchCartItems(userId);
        print("Cart Items: $_cartItems");
        _itemCount = _cartItems.length; // Cập nhật số lượng sản phẩm
        print("Cart items loaded: $_cartItems");
      }
    } catch (e) {
      print("Error fetching cart items: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(int productId, int? userId, int quantity, double price,
      String size) async {
    try {
      await _cartService.addToCart(productId, userId, quantity, price, size);

      // Fetch lại dữ liệu giỏ hàng
      await fetchCartItems();
    } catch (e) {
      print("Error adding item to cart: $e");
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeCartItem(int cartId) async {
    try {
      await _cartService.removeCartItem(cartId);
      _cartItems.removeWhere(
          (item) => item.id == cartId); // Xóa sản phẩm khỏi danh sách
      _itemCount = _cartItems.length; // Cập nhật lại số lượng
      notifyListeners(); // Cập nhật giao diện
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  // Toggle trạng thái checkbox
  void toggleItemSelection(int id, bool isSelected) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].isSelected = isSelected;
      notifyListeners();
    }
  }

  Timer? _debounce;

  // Tăng số lượng sản phẩm
  void increaseQuantity(BuildContext context, int id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      // Kiểm tra nếu số lượng vượt quá stock
      if (_cartItems[index].quantity < _cartItems[index].stock) {
        _cartItems[index].quantity += 1;
        notifyListeners();

        // Gọi API cập nhật số lượng (nếu cần)
        _scheduleDebouncedUpdate(id, _cartItems[index].quantity);
      } else {
        // Hiển thị thông báo nếu vượt quá số lượng kho
        OverlayHelper.showCustomOverlayMessage(
            context, 'Sản phẩm vượt quá số lượng kho');
      }
    }
  }

  // Giảm số lượng sản phẩm
  void decreaseQuantity(int id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
        notifyListeners();

        _scheduleDebouncedUpdate(id, _cartItems[index].quantity);
      } else {
        removeCartItem(id); // Xóa sản phẩm nếu số lượng là 0
      }
    }
  }

  // Lên lịch cập nhật CSDL với debounce
  void _scheduleDebouncedUpdate(int id, int quantity) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        await _cartService.updateCartItem(id, quantity);
        print("Cập nhật thành công sản phẩm $id với số lượng $quantity");
      } catch (e) {
        print("Lỗi khi cập nhật sản phẩm: $e");
      }
    });
  }

  // Tính tổng tiền của các sản phẩm được chọn
  double get totalSelectedPrice {
    return _cartItems
        .where((item) => item.isSelected) // Lọc các sản phẩm được chọn
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // lượng check
  int get totalSelectedItems {
    return _cartItems.where((item) => item.isSelected).length;
  }

  void toggleSelectAll(bool isSelected) {
    for (var item in _cartItems) {
      item.isSelected = isSelected;
    }
    notifyListeners();
  }

  List<CartItem> get selectedCartItems {
    return _cartItems.where((item) => item.isSelected).toList();
  }
  // Xóa tất cả sản phẩm được chọn khỏi giỏ hàng
  Future<void> clearSelectedItems() async {
    try {
      // Lọc các sản phẩm được chọn
      final selectedItems =
          _cartItems.where((item) => item.isSelected).toList();

      // Xóa từng sản phẩm được chọn
      for (var item in selectedItems) {
        await _cartService.removeCartItem(item.id); // Gọi API để xóa sản phẩm
        _cartItems.removeWhere((cartItem) =>
            cartItem.id == item.id); // Xóa sản phẩm khỏi danh sách giỏ hàng
      }
      _itemCount = _cartItems.length; // Cập nhật lại số lượng sản phẩm
      notifyListeners(); // Cập nhật giao diện
    } catch (e) {
      print("Error clearing selected items: $e");
    }
  }
}

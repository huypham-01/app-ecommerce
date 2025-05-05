import 'package:flutter/material.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = true;
  Product? _product;
  String? _error;

  Product? get product => _product;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners(); // Cập nhật trạng thái loading
      _products = await ProductService().fetchProducts();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Cập nhật trạng thái và dữ liệu
    }
  }

  Future<void> fetchProductDetails(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _product = await ProductService().fetchProductDetail(productId);
    } catch (e) {
      _error = e.toString();
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

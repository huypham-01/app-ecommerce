import 'package:flutter/material.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/services/categoty_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  final CategoryService _categoryService = CategoryService();

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners(); // Thông báo bắt đầu tải dữ liệu
      final fetchedCategories = await _categoryService.fetchCategories();
      _categories = fetchedCategories
          .where((category) => category.isParent == 1)
          .toList();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo dữ liệu đã sẵn sàng
    }
  }
}

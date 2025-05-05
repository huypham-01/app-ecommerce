import 'package:dio/dio.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/category_model.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categoryUrl);
      // print(response.data);
      return (response.data as List)
          .map((category) => Category.fromJson(category))
          .toList();
          
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }
}

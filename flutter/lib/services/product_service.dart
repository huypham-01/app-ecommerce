import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'package:shop/constants.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(ApiConstants.productUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final response =
        await http.get(Uri.parse('${ApiConstants.productUrl}/$id'));

    if (response.statusCode == 200) {
      print(response.body);
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}

// class ProductService {
//   final Dio _dio = Dio();

//   Future<List> fetchFeaturedProducts() async {
//     try {
//       final response =
//           await _dio.get(ApiConstants.productUrl);
//       return response.data;
//     } catch (e) {
//       print("Error fetching featured products: $e");
//       return [];
//     }
//   }
// }

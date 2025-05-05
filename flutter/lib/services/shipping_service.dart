import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shop/constants.dart';

class ShippingService {
  Future<List<dynamic>> fetchShippingMethods() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/shipping'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load shipping methods');
    }
  }
}

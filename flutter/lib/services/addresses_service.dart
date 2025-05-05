import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/constants.dart';
import 'package:shop/models/address_model.dart';
import 'package:shop/services/user_servece.dart';

class AddressService {
  final String apiUrl = ApiConstants.addressesUrl;
  Future<void> saveAddress(Map<String, dynamic> addressData) async {
    final url = Uri.parse('$apiUrl/add');
    final token = gettoken();
    final headers = {
      "Content-Type": "application/json", // Định dạng JSON UTF-8
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Gửi token trong header
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(addressData),
    );

    if (response.statusCode == 200) {
      print('Thành công: ${response.body}');
    } else {
      print('Lỗi: ${response.body}');
    }
  }

  // Hàm lấy dữ liệu địa chỉ từ API
  Future<List<Address>> fetchAddresses(int userId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/index/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  Future<void> updateAddress(
      Map<String, dynamic> updatedAddressData, int id) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token_here',
      },
      body: jsonEncode(updatedAddressData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update address: ${response.body}');
    }

    print('Address updated successfully');
  }
}

import 'package:flutter/material.dart';
import 'package:shop/services/addresses_service.dart';
import 'package:shop/services/user_servece.dart';

import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final AddressService _addressService = AddressService();

  List<Address> _addresses = [];
  bool _isLoading = false;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;


  Future<void> fetchAddresses() async {
    final userId = await getUserId();
    if (userId != null) {
      _isLoading = true;
      notifyListeners();

      try {
        _addresses = await _addressService.fetchAddresses(userId);
      } catch (e) {
        print('Error: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('User ID not found');
    }
  }
  // Getter để lấy địa chỉ mặc định
  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null; // Không tìm thấy địa chỉ mặc định
    }
  }

  Future<void> saveAddress(Map<String, dynamic> addressData) async {
    try {
      await _addressService.saveAddress(addressData);
      // Không cập nhật _addresses ở đây để đảm bảo fetchAddresses là nguồn dữ liệu chính
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAddress(
      Map<String, dynamic> updatedAddressData, int id) async {
    try {
      await _addressService.updateAddress(
          updatedAddressData, id); // Gửi yêu cầu API
      fetchAddresses(); // Tải lại danh sách từ server
    } catch (e) {
      rethrow;
    }
  }
  
}

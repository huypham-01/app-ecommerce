import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/addresses_provider.dart';
import 'package:shop/services/user_servece.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController streetController = TextEditingController();

  String selectedAddressType = "Nhà riêng";
  bool isDefaultAddress = false;

  void _submitAddress() async {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final userId = await getUserId();
    final addressData = {
      "user_id": userId,
      "name": nameController.text,
      "phone": phoneController.text,
      "province": provinceController.text,
      "district": districtController.text,
      "ward": wardController.text,
      "street": streetController.text,
      "address_type": selectedAddressType,
      "is_default": isDefaultAddress,
    };

    try {
      await addressProvider.saveAddress(addressData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm địa chỉ thành công')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu địa chỉ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Địa chỉ mới',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Liên hệ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTextField('Họ và tên', TextInputType.text, nameController),
              const SizedBox(height: 16),
              _buildTextField(
                  'Số điện thoại', TextInputType.phone, phoneController),
              const SizedBox(height: 16),
              const Text(
                'Địa chỉ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                  'Tỉnh/thành phố', TextInputType.text, provinceController),
              const SizedBox(height: 8),
              _buildTextField(
                  'Quận/huyện', TextInputType.text, districtController),
              const SizedBox(height: 8),
              _buildTextField('Phường/xã', TextInputType.text, wardController),
              const SizedBox(height: 8),
              _buildTextField('Tên đường, Toà nhà, Số nhà.', TextInputType.text,
                  streetController),
              const SizedBox(height: 16),
              const Text(
                'Cài đặt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text('Loại địa chỉ:'),
                  const SizedBox(width: 16),
                  _buildAddressTypeButton("Văn phòng"),
                  const SizedBox(width: 8),
                  _buildAddressTypeButton("Nhà riêng"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Đặt làm địa chỉ mặc định'),
                  Switch(
                    value: isDefaultAddress,
                    onChanged: (value) {
                      setState(() {
                        isDefaultAddress = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _submitAddress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'HOÀN THÀNH',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextInputType keyboardType,
      TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: keyboardType,
    );
  }

  Widget _buildAddressTypeButton(String type) {
    final isSelected = selectedAddressType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          type,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.orange,
          ),
        ),
      ),
    );
  }
}

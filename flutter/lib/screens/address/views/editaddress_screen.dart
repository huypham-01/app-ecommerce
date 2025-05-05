import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/addresses_provider.dart';
import 'package:shop/models/address_model.dart';

class EditAddressScreen extends StatefulWidget {
  final Address address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController provinceController;
  late TextEditingController districtController;
  late TextEditingController wardController;
  late TextEditingController streetController;

  String selectedAddressType = "Nhà riêng";
  bool isDefaultAddress = true;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    nameController = TextEditingController(text: address.name);
    phoneController = TextEditingController(text: address.phone);
    provinceController = TextEditingController(text: address.province);
    districtController = TextEditingController(text: address.district);
    wardController = TextEditingController(text: address.ward);
    streetController = TextEditingController(text: address.street);
    selectedAddressType = address.type ?? "Nhà riêng";
    isDefaultAddress = address.isDefault ?? false;
  }

  void _submitAddress() async {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    final updatedAddressData = {
      "id": widget.address.id, // ID của địa chỉ cần sửa
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
      await addressProvider.updateAddress(
          updatedAddressData, widget.address.id); // Gửi yêu cầu sửa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật địa chỉ thành công')),
      );
      Navigator.pop(context, true); // Trả về true khi sửa thành công
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật địa chỉ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa địa chỉ',
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

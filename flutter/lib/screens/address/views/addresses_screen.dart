import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/addresses_provider.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/address/views/editaddress_screen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchAddresses một lần khi widget được khởi tạo
    _loadAddresses();
  }

  void _loadAddresses() {
    Future.delayed(Duration.zero, () {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Địa chỉ của Tôi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: addressProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Hiển thị loading khi đang tải dữ liệu
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: addressProvider.addresses.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final address = addressProvider.addresses[index];
                      return GestureDetector(
                        onTap: () async {
                          // Điều hướng đến màn hình chỉnh sửa địa chỉ
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditAddressScreen(address: address),
                            ),
                          );

                          // Nếu cập nhật thành công, tải lại danh sách
                          if (result == true) {
                            _loadAddresses();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    address.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const SizedBox(
                                    child: Text('|'),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    address.phone,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address.fullAddress,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),

                              // Trạng thái "Mặc định" hoặc "Địa chỉ lấy hàng"
                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Mặc định',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Thêm Địa Chỉ Mới',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          addNewAddressesScreenRoute,
                        );
                        if (result == true) {
                          _loadAddresses(); // Tải lại danh sách nếu thêm thành công
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

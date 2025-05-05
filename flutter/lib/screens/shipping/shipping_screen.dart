import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/shipping_provider.dart';

class ShippingMethodScreen extends StatelessWidget {
  const ShippingMethodScreen({super.key});

  // Tính toán ngày nhận hàng

  @override
  Widget build(BuildContext context) {
    final shippingProvider = Provider.of<ShippingProvider>(context);

    // Gọi API để tải danh sách phương thức vận chuyển
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shippingProvider.shippingMethods.isEmpty) {
        shippingProvider.fetchShippingMethods();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phương thức vận chuyển"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header mô tả
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Các phương thức vận chuyển của Shop\n"
              "Bạn có thể theo dõi đơn hàng trên ứng dụng khi chọn một trong các phương thức vận chuyển:",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          // Danh sách phương thức vận chuyển
          Expanded(
            child: ListView.builder(
              itemCount: shippingProvider.shippingMethods.length,
              itemBuilder: (context, index) {
                final method = shippingProvider.shippingMethods[index];
                final isSelected = method['id'].toString() ==
                    shippingProvider.selectedShippingMethod;

                return GestureDetector(
                  onTap: () {
                    shippingProvider
                        .selectShippingMethod(method['id'].toString());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? Colors.red : Colors.transparent,
                          width: 5,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.red.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              method['type'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSelected ? Colors.red : Colors.black,
                              ),
                            ),
                            Text(
                              "${method['price']} đ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Dateship.calculateDeliveryDate(method['delivery']),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 7, 134, 226)),
                        ),
                        if (isSelected)
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.check_circle, color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Nút Xác nhận
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                final selectedMethod = shippingProvider.selectedShippingMethod;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Đã chọn phương thức vận chuyển: $selectedMethod",
                    ),
                  ),
                );

                // Logic tiếp theo: Xử lý đặt hàng hoặc chuyển màn hình
              },
              child: const Center(
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

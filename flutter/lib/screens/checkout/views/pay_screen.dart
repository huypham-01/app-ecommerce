import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/addresses_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/providers/shipping_provider.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/services/user_servece.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String? selectedPaymentMethod = 'cod'; // Lưu phương thức thanh toán được chọn
  @override
  void initState() {
    super.initState();
    // Gọi fetchAddresses khi khởi tạo màn hình
    Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    Provider.of<ShippingProvider>(context, listen: false)
        .fetchShippingMethods();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final shippingProvider = Provider.of<ShippingProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 49, 19, 215)), // Màu mũi tên quay lại
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Phần hiển thị địa chỉ
                  buildAddressDetails(context, addressProvider),
                  // Phần chi tiết sản phẩm
                  buildProductDetails(context, cartProvider),
                  // phần phương thức vận chuyển
                  builShipDetails(context, shippingProvider),
                  // Phần phương thức thanh toán
                  builMethodDetails(context),
                  // Chi tếit đơn hàng
                  builOrderDetails(context),
                ],
              ),
            ),
          ),

          // Phần thanh toán
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tổng thanh toán
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Tổng thanh toán\n',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '₫ ${formatPrice((cartProvider.totalSelectedPrice + (shippingProvider.selectedShippingMethod != null ? double.parse(shippingProvider.shippingMethods.firstWhere((method) => method['id'].toString() == shippingProvider.selectedShippingMethod)['price']) : 0)))}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Nút "Đặt hàng"
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: cartProvider.totalSelectedItems > 0
                            ? Colors.orange
                            : Colors.grey, // Nút xám nếu không có sản phẩm
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: cartProvider.totalSelectedItems > 0
                          ? () async {
                              // Kiểm tra điều kiện phương thức vận chuyển
                              if (shippingProvider.selectedShippingMethod ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Vui lòng chọn phương thức vận chuyển!',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                                return;
                              }
                              // Kiểm tra phương thức thanh toán
                              if (selectedPaymentMethod == 'bank_transfer') {
                                // Nếu phương thức thanh toán là chuyển khoản, điều hướng đến trang giao dịch
                                Navigator.pushNamed(
                                    context, bankTransferScreenRoute);
                              } else {
                                // Nếu phương thức thanh toán là COD, tiếp tục với đơn hàng
                                Map<String, String> nameParts =
                                    SplitFullname.splitFullName(
                                        addressProvider.defaultAddress!.name);

                                // Chuẩn bị dữ liệu đơn hàng
                                final orderData = {
                                  "order_number":
                                      "ORD-${DateTime.now().millisecondsSinceEpoch}",
                                  "user_id": await getUserId(),
                                  "sub_total": cartProvider.totalSelectedPrice,
                                  "shipping_id": int.parse(
                                      shippingProvider.selectedShippingMethod!),
                                  "coupon": 0,
                                  "total_amount": cartProvider
                                          .totalSelectedPrice +
                                      double.parse(shippingProvider
                                              .shippingMethods
                                              .firstWhere((method) =>
                                                  method['id'].toString() ==
                                                  shippingProvider
                                                      .selectedShippingMethod)[
                                          'price']),
                                  "payment_method":
                                      "cod", // Thanh toán khi nhận hàng
                                  "first_name": nameParts['first_name'],
                                  "last_name": nameParts['last_name'],
                                  "email": "user@example.com",
                                  "phone":
                                      addressProvider.defaultAddress?.phone,
                                  "country": "Vietnam",
                                  "post_code":
                                      addressProvider.defaultAddress?.type,
                                  "address1": addressProvider
                                      .defaultAddress?.fullAddress,
                                  "address2": "null",
                                  "items": cartProvider.selectedCartItems
                                      .map((item) {
                                    return {
                                      "product_id": item.productId,
                                      "size": item.size,
                                      "quantity": item.quantity,
                                      "price": item.price,
                                    };
                                  }).toList(),
                                };

                                // Gọi Provider để gửi dữ liệu
                                final orderProvider =
                                    Provider.of<OrderProvider>(context,
                                        listen: false);
                                final success =
                                    await orderProvider.placeOrder(orderData);

                                if (success) {
                                  OverlayHelper.showCustomOverlayMessage(
                                      context,
                                      'Bạn đã hoàn tất quá trình đặt hàng');
                                  await cartProvider.clearSelectedItems();
                                  // Điều hướng đến trang OrderSuccess
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Đặt hàng thất bại!")),
                                  );
                                }
                              }
                            }
                          : null, // Vô hiệu hóa nếu không có sản phẩm được chọn // Vô hiệu hóa nếu không có sản phẩm được chọn
                      child: const Text(
                        'Đặt hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Phần chi tiết sản phẩm
  Widget buildProductDetails(BuildContext context, CartProvider cartProvider) {
    final selectedItems =
        cartProvider.selectedCartItems; // Lấy danh sách sản phẩm được chọn

    if (selectedItems.isEmpty) {
      return const Center(
        child: Text('Không có sản phẩm nào được chọn'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Để danh sách không cuộn
      itemCount: selectedItems.length,
      itemBuilder: (context, index) {
        final product = selectedItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(102, 203, 212, 216),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image.replaceFirst(ApiConstants.local,
                          ApiConstants.ifcon), // URL ảnh từ sản phẩm
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Thông tin sản phẩm
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Hiển thị tối đa 1 dòng
                          overflow: TextOverflow
                              .ellipsis, // Hiển thị "..." nếu quá dài
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Kích thước: ${product.size}", // Kích thước sản phẩm
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "₫ ${formatPrice(product.price)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                // if (product.originalPrice > product.price)
                                //   Text(
                                //     "₫${product.originalPrice.toStringAsFixed(0)}",
                                //     style: const TextStyle(
                                //       fontSize: 12,
                                //       color: Colors.grey,
                                //       decoration: TextDecoration
                                //           .lineThrough, // Gạch ngang giá gốc
                                //     ),
                                //   ),
                              ],
                            ),
                            Text(
                              "x${product.quantity}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAddressDetails(
      BuildContext context, AddressProvider addressProvider) {
    if (addressProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final defaultAddress = addressProvider.defaultAddress;

    if (defaultAddress == null) {
      return const Center(
        child: Text('Chưa có địa chỉ mặc định'),
      );
    }

    return GestureDetector(
      onTap: () {
        // Điều hướng đến danh sách địa chỉ
        Navigator.pushNamed(context, addressesScreenRoute);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                const Color.fromARGB(102, 203, 212, 216), // Nền màu xanh nhạt
            borderRadius: BorderRadius.circular(8), // Bo góc
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          defaultAddress.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          defaultAddress.phone,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 106, 98, 98)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${defaultAddress.street}, ${defaultAddress.ward}, ${defaultAddress.district}, ${defaultAddress.province}",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 118, 113, 113),
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60, // Đảm bảo chiều cao bằng nội dung
                child: Center(
                  child: Icon(Icons.arrow_forward_ios,
                      size: 16), // Căn giữa biểu tượng
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget builShipDetails(
      BuildContext context, ShippingProvider shippingProvider) {
    // Lấy phương thức vận chuyển đã chọn
    final selectedShippingMethod = shippingProvider.shippingMethods.firstWhere(
      (method) =>
          method['id'].toString() == shippingProvider.selectedShippingMethod,
      orElse: () => null,
    );
    // Nếu chưa chọn phương thức vận chuyển, hiển thị mặc định
    if (selectedShippingMethod == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                const Color.fromARGB(102, 203, 212, 216), // Nền màu xanh nhạt
            borderRadius: BorderRadius.circular(8), // Bo góc
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề và nút "Xem thêm"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Phương thức vận chuyển",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Hành động khi nhấn "Xem thêm"
                      Navigator.pushNamed(context, shippingMethodScreenRoute);
                    },
                    child: const Text(
                      "Xem thêm >",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 96, 90, 90),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Chưa chọn phương thức vận chuyển",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Hiển thị thông tin phương thức đã chọn
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(102, 203, 212, 216), // Nền màu xanh nhạt
          borderRadius: BorderRadius.circular(8), // Bo góc
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và nút "Xem thêm"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Phương thức vận chuyển",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Hành động khi nhấn "Xem thêm"
                    Navigator.pushNamed(context, shippingMethodScreenRoute);
                  },
                  child: const Text(
                    "Xem thêm >",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 96, 90, 90),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Khung vận chuyển
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50, // Màu nền nhạt
                border: Border.all(color: Colors.green.shade300), // Viền
                borderRadius: BorderRadius.circular(8), // Bo góc
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedShippingMethod['type'] ?? "Không rõ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      Text(
                        "₫${selectedShippingMethod['price']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Dateship.calculateDeliveryDate(
                        selectedShippingMethod['delivery']),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builMethodDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(102, 203, 212, 216), // Nền màu xanh nhạt
          borderRadius: BorderRadius.circular(8), // Bo góc
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và nút "Xem thêm"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Phương thức thanh toán",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.red),
              title: const Text("Thanh toán khi nhận hàng"),
              trailing: Radio<String>(
                value: 'cod',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance, color: Colors.blue),
              title: const Text("Thanh toán chuyển khoản"),
              trailing: Radio<String>(
                value: 'bank_transfer',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builOrderDetails(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final shippingProvider = Provider.of<ShippingProvider>(context);

    // Lấy phương thức vận chuyển đã chọn
    final selectedShippingMethod = shippingProvider.shippingMethods.firstWhere(
      (method) =>
          method['id'].toString() == shippingProvider.selectedShippingMethod,
      orElse: () => null,
    );

    // Tính toán các giá trị
    final totalItemsPrice = cartProvider.totalSelectedPrice; // Tổng tiền hàng
    final shippingFee = selectedShippingMethod != null
        ? double.parse(selectedShippingMethod['price'].toString())
        : 0.0; // Phí vận chuyển
    final totalPayment = totalItemsPrice + shippingFee; // Tổng thanh toán

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(102, 203, 212, 216), // Nền màu xanh nhạt
          borderRadius: BorderRadius.circular(8), // Bo góc
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Chi tiết thanh toán",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Hiển thị chi tiết thanh toán
            _buildPaymentDetailRow(
                "Tổng tiền hàng", "₫ ${formatPrice(totalItemsPrice)}"),
            _buildPaymentDetailRow(
                "Tổng tiền phí vận chuyển", "₫ ${formatPrice(shippingFee)}"),
            const Divider(),
            _buildPaymentDetailRow(
                "Tổng thanh toán", "₫ ${formatPrice(totalPayment)}",
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(String title, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/route/screen_export.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ CartProvider
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 49, 19, 215)), // Màu mũi tên quay lại
        title: Text(
          'Giỏ hàng (${cartProvider.cartItems.length})',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Hành động khi nhấn nút "Sửa"
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Chức năng sửa đang phát triển...')),
              );
            },
            child: const Text(
              'Sửa',
              style: TextStyle(
                color: Color.fromARGB(255, 116, 103, 102),
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          // Danh sách sản phẩm
          Expanded(
            child: cartProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : cartProvider.cartItems.isEmpty
                    ? const Center(child: Text('Giỏ hàng trống'))
                    : ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //checkbox
                                Checkbox(
                                  value: item
                                      .isSelected, // Cần thêm thuộc tính isSelected trong model
                                  onChanged: (bool? value) {
                                    cartProvider.toggleItemSelection(
                                        item.id, value ?? false);
                                  },
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        item.image.replaceFirst(
                                            ApiConstants.local,
                                            ApiConstants.ifcon),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Thông tin sản phẩm
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Tên sản phẩm
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1, // Hiển thị tối đa 1 dòng
                                        overflow: TextOverflow
                                            .ellipsis, // Thay thế phần dư bằng dấu ...
                                      ),

                                      // Giá sản phẩm
                                      Text(
                                        '${formatPrice(item.price)} đ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Kích thước
                                      Text(
                                        'Kích thước: ${item.size}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      // Tăng/giảm số lượng
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (item.quantity > 1) {
                                                cartProvider
                                                    .decreaseQuantity(item.id);
                                              } else {
                                                // Nếu số lượng là 1, giảm tiếp sẽ xóa sản phẩm
                                                _showConfirmDialog(context, () {
                                                  cartProvider
                                                      .removeCartItem(item.id);
                                                });
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.remove_circle,
                                                color: Color.fromARGB(
                                                    255, 160, 152, 152)),
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              cartProvider.increaseQuantity(
                                                  context, item.id);
                                            },
                                            icon: const Icon(Icons.add_circle,
                                                color: Color.fromARGB(
                                                    255, 160, 152, 152)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                  // Checkbox "Tất cả"
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3, // Tăng kích thước checkbox
                        child: Checkbox(
                          value: cartProvider.isAllSelected,
                          onChanged: (bool? value) {
                            cartProvider.toggleSelectAll(value ?? false);
                          },
                        ),
                      ),
                      const Text(
                        'Tất cả',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      width: 15), // Khoảng cách giữa checkbox và chữ "Tất cả"
                  // Tổng thanh toán
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Tổng thanh toán ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${formatPrice(cartProvider.totalSelectedPrice)} đ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   'Tiết kiệm đ478k', // Thay số tiết kiệm thực tế ở đây nếu cần
                        //   style: const TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.orange,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // Nút "Mua hàng"
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        if (cartProvider.totalSelectedItems > 0) {
                          // Xử lý đặt hàng
                          Navigator.pushNamed(context, payScreenRoute);
                        } else {
                          // Thông báo lỗi nếu chưa chọn sản phẩm
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Vui lòng chọn sản phẩm trước khi đặt hàng!',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Mua hàng (${cartProvider.totalSelectedItems})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Bạn muốn xoá sản phẩm này?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content:
              const Text("Nếu bạn nhấn huỷ bỏ, sẽ không có thay đổi gì xảy ra"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Huỷ bỏ"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                onConfirm(); // Gọi hàm xác nhận
              },
              child: const Text(
                "Xác nhận xoá",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

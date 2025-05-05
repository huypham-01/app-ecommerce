import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/order_status_model.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/product/views/product_review_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders(); // Chỉ gọi một lần khi màn hình được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    // Fetch orders when the screen is loaded
    final orderProvider = Provider.of<OrderProvider>(context);

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đơn đã mua'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã huỷ'),
            ],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            if (orderProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (orderProvider.hasError) {
              return Center(child: Text('lỗi.'));
            }

            return TabBarView(
              children: [
                buildOrderList(orderProvider.filterOrdersByStatus('new')),
                buildOrderList(orderProvider.filterOrdersByStatus('process')),
                buildOrderList(orderProvider.filterOrdersByStatus('delivered')),
                buildOrderList(orderProvider.filterOrdersByStatus('cancel')),
              ],
            );
          },
        ),
      ),
    );
  }

  // Build the list of orders for each status tab
  Widget buildOrderList(List<OrderItem> orders) {
    if (orders.isEmpty) {
      return Center(child: Text('Bạn chưa có đơn hàng nào'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(102, 203, 212, 216),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh sản phẩm
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.image.replaceFirst(ApiConstants.local,
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
                              order.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Hiển thị tối đa 1 dòng
                              overflow: TextOverflow
                                  .ellipsis, // Hiển thị "..." nếu quá dài
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Kích thước: ${order.size}", // Kích thước sản phẩm
                              style: const TextStyle(
                                fontSize: 12,
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
                                      "₫ ${formatPrice(order.price)}",
                                      style: const TextStyle(
                                        fontSize: 15,
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
                                  "x${order.quantity}",
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
                  const Divider(),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Tổng số tiền (1 sản phẩm): ",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 3, 3, 3),
                            ),
                          ),
                          Text(
                            "${formatPrice(order.totalAmount)} đ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      if (order.status == 'new')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Gọi phương thức cancelOrder từ provider để hủy đơn
                                await Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .cancelOrder(order.id);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                minimumSize: Size(70,
                                    40), // Điều chỉnh chiều rộng và chiều cao
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Hủy Đơn',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                      else if (order.status == 'process')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Gọi phương thức markAsDelivered từ provider để đánh dấu đơn hàng là đã nhận
                                await Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .markAsDelivered(order.id);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                minimumSize: Size(70,
                                    40), // Điều chỉnh chiều rộng và chiều cao
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Đã nhận được hàng',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                      else if (order.status == 'delivered')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  productDetailsScreenRoute,
                                  arguments: {
                                    'isEven': index.isEven,
                                    'productId': order.productId,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                minimumSize: Size(70,
                                    40), // Điều chỉnh chiều rộng và chiều cao
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Mua lại',
                                  style: TextStyle(fontSize: 14)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductReviewScreen(
                                        productId: order
                                            .productId), // Truyền productId của đơn hàng
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                minimumSize: Size(70,
                                    40), // Điều chỉnh chiều rộng và chiều cao
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Đánh giá',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                      else if (order.status == 'cancel')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                minimumSize: Size(70,
                                    40), // Điều chỉnh chiều rộng và chiều cao
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Mua lại',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

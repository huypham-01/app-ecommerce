import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/product/views/components/review_tile.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';

import '../../../services/product_service.dart';
import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';
import 'dart:math';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, this.isProductAvailable = true, required this.productId});
  final int productId;
  final bool isProductAvailable;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<Product> product;
  bool isExpanded = false;
  Product? productData;
  // Trạng thái xem toàn bộ mô tả
  @override
  void initState() {
    super.initState();
    product = ProductService().fetchProductDetail(widget.productId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Product>(
          future: product,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi khi tải dữ liệu"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("Không có dữ liệu"));
            } else {
              final productData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        productData.image.replaceFirst(
                            ApiConstants.local, ApiConstants.ifcon),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("Thương hiệu: ${productData.brandName}",
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          // Giá
                          Row(
                            children: [
                              if (productData.discount != null)
                                Text(
                                  "đ ${formatPrice(productData.price * (1 - productData.discount! / 100))}",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              const SizedBox(width: 8),
                              if (productData.priceAfetDiscount !=
                                  productData.price)
                                Text(
                                  "đ ${formatPrice(productData.price)}",
                                  style: TextStyle(
                                    color: productData.discount != null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize:
                                        productData.discount != null ? 16 : 20,
                                    decoration: productData.discount != null
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              // Spacer để căn giữa với số lượng đã bán
                              const Spacer(),
                              // Hiển thị số lượng đã bán
                              Text(
                                "Số lượng: ${productData.stock}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 26, 25, 25),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          // Mô tả

                          Text("Mô tả sản phẩm",
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hiển thị đoạn mô tả, nếu `isExpanded` là `true` sẽ hiển thị toàn bộ
                              Text(
                                isExpanded
                                    ? productData
                                        .description // Hiển thị toàn bộ mô tả
                                    : (productData.description.length >
                                            100 // Nếu mô tả dài hơn 100 ký tự, cắt bớt
                                        ? '${productData.description.substring(0, 100)}...' // Hiển thị 100 ký tự đầu tiên
                                        : productData
                                            .description), // Hiển thị toàn bộ nếu dưới 100 ký tự
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              // Nút "Xem thêm" hoặc "Thu gọn"
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded =
                                        !isExpanded; // Thay đổi trạng thái khi nhấn vào
                                  });
                                },
                                child: Text(
                                  isExpanded ? 'Thu gọn' : 'Xem thêm',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Đánh giá sản phẩm
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExpansionTile(
                                  initiallyExpanded: true,
                                  childrenPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  tilePadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  title: Text("Đánh giá sản phẩm",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (productData.reviews.isNotEmpty)
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ReviewTile(
                                                review:
                                                    productData.reviews[index]),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 16),
                                        itemCount: min(
                                            2,
                                            productData.reviews
                                                .length), // Số lượng đánh giá thực tế hoặc tối đa là 2
                                      )
                                    else
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 16, top: 8),
                                        child: Text(
                                          'Chưa có đánh giá nào cho sản phẩm này.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    if (productData.reviews.length > 2)
                                      GestureDetector(
                                        onTap: () {
                                          // Hành động khi nhấn vào "Xem thêm"
                                        },
                                        child: Text(
                                          'Xem thêm đánh giá',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromARGB(
                                                      255, 121, 123, 124),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
      bottomNavigationBar: FutureBuilder<Product>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị một thanh tiến trình hoặc khoảng trống khi chưa có dữ liệu
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            final productData = snapshot.data!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        customModalBottomSheet(
                          context,
                          height: MediaQuery.of(context).size.height * 0.92,
                          child: ProductBuyNowScreen(
                            id: productData.id,
                            title: productData.title,
                            image: productData.image,
                            price: productData.price,
                            priceAfetDiscount: productData.priceAfetDiscount,
                            dicountpercent: productData.discount,
                            size: productData.size,
                            stock: productData.stock,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Thêm vào giỏ hàng"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý mua ngay
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Mua ngay"),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Hiển thị khi có lỗi hoặc không có dữ liệu
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

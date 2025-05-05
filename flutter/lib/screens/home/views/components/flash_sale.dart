import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/product_service.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({
    super.key,
  });

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  late Future<List<Product>> futureProducts;
  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Siêu ưu đãi lên đến 50%",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Container(
          color: const Color.fromARGB(211, 237, 238, 239),
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sản phẩm HOT",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: const Color.fromARGB(255, 27, 90,
                              142), // Màu xanh đậm cho nút "Xem thêm"
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Hành động khi nhấn vào "Xem thêm"
                      },
                      child: Text(
                        "Xem thêm >>",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color.fromARGB(255, 121, 123, 124),
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Product>>(
                future:
                    futureProducts, // Hàm API hoặc lấy dữ liệu sản phẩm từ cơ sở dữ liệu
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có sản phẩm nào.'));
                  } else {
                    // Lọc các sản phẩm có condition = "hot"
                    final hotProducts = snapshot.data!
                        .where((product) => product.condition == "hot")
                        .toList();

                    if (hotProducts.isEmpty) {
                      return const Center(
                          child: Text('Không có sản phẩm nào.'));
                    }

                    return SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotProducts.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding,
                            right: index == hotProducts.length - 1
                                ? defaultPadding
                                : 0,
                          ),
                          child: ProductCard(
                            image: hotProducts[index].image,
                            brandName: hotProducts[index].brandName,
                            title: hotProducts[index].title,
                            price: hotProducts[index].price,
                            priceAfetDiscount:
                                hotProducts[index].priceAfetDiscount,
                            dicountpercent: hotProducts[index].discount,
                            press: () {
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: {'productId': hotProducts[index].id},
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),

        // SizedBox(
        //   height: 220,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     // Find demoFlashSaleProducts on models/ProductModel.dart
        //     itemCount: demoFlashSaleProducts.length,
        //     itemBuilder: (context, index) => Padding(
        //       padding: EdgeInsets.only(
        //         left: defaultPadding,
        //         right: index == demoFlashSaleProducts.length - 1
        //             ? defaultPadding
        //             : 0,
        //       ),
        //       child: ProductCard(
        //         image: demoFlashSaleProducts[index].image,
        //         brandName: demoFlashSaleProducts[index].brandName,
        //         title: demoFlashSaleProducts[index].title,
        //         price: demoFlashSaleProducts[index].price,
        //         priceAfetDiscount:
        //             demoFlashSaleProducts[index].priceAfetDiscount,
        //         dicountpercent: demoFlashSaleProducts[index].dicountpercent,
        //         press: () {
        //           Navigator.pushNamed(context, productDetailsScreenRoute,
        //               arguments: index.isEven);
        //         },
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/providers/product_provider.dart';

import '../../../../constants.dart';
import '../../../../route/screen_export.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  @override
  void initState() {
    super.initState();
    // Gọi hàm fetchProducts từ Provider
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ ProductProvider
    final productProvider = Provider.of<ProductProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      "Phổ biến",
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
              productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : productProvider.products.isEmpty
                      ? const Center(child: Text('Không có sản phẩm nào.'))
                      : SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.products.length,
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              // Lọc sản phẩm theo condition = "default"
                              if (product.condition != "default") {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: defaultPadding,
                                  right: index ==
                                          productProvider.products.length - 1
                                      ? defaultPadding
                                      : 0,
                                ),
                                child: ProductCard(
                                  image: product.image,
                                  brandName: product.brandName,
                                  title: product.title,
                                  price: product.price,
                                  dicountpercent: product.discount,
                                  priceAfetDiscount: product.priceAfetDiscount,
                                  press: () {
                                    Navigator.pushNamed(
                                      context,
                                      productDetailsScreenRoute,
                                      arguments: {
                                        'isEven': index.isEven,
                                        'productId': product.id
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ],
    );
  }
}

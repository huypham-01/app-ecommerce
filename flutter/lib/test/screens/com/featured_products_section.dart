import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';
import '../../../../services/product_service.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({
    super.key,
  });

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
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
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Phổ biến",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Hiển thị vòng xoay khi đang tải dữ liệu
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Hiển thị lỗi nếu việc tải dữ liệu thất bại
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Hiển thị khi không có dữ liệu
              return const Center(child: Text('Không có sản phẩm nào.'));
            } else {
              // Khi dữ liệu đã tải thành công, hiển thị danh sách sản phẩm
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == snapshot.data!.length - 1
                            ? defaultPadding
                            : 0,
                      ),
                      child: ProductCard(
                        image: product.image,
                        brandName: product.brandName,
                        title: product.title,
                        price: product.price,
                        dicountpercent: product.discount,
                        press: () {},
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';

import '../../../../constants.dart';
import 'categories.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OffersCarousel(),
        const SizedBox(height: defaultPadding / 2),
        Container(
          color: const Color.fromARGB(211, 237, 238, 239), // Màu nền xanh nhạt
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row chứa tiêu đề và nút "Xem thêm"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Danh mục sản phẩm",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: const Color.fromARGB(255, 27, 90,
                              142), // Màu xanh đậm cho nút "Xem thêm"
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Hành động khi nhấn vào "Xem thêm"
                    //     // Navigator.pushNamed(context, discoverScreenRoute);
                    //   },
                    //   child: Text(
                    //     "Xem thêm >>",
                    //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    //         color: const Color.fromARGB(255, 121, 123, 124),
                    //         fontWeight: FontWeight.normal,
                    //         fontSize: 12),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding / 2),

              // Widget Categories nằm bên trong nền xanh
              const Categories(),
            ],
          ),
        ),
      ],
    );
  }
}

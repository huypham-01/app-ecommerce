import 'package:flutter/material.dart';

import '../../constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.press,
  });
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(140, 220),
          maximumSize: const Size(140, 220),
          padding: const EdgeInsets.all(8)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Bo góc hình ảnh
                    border: Border.all(
                        color: Colors.grey.shade300), // ₫ường viền màu xám
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Bo góc
                    child: Image.network(
                      image.replaceFirst(
                          ApiConstants.local, ApiConstants.ifcon),
                      fit: BoxFit.cover, // Cân chỉnh hình ảnh
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                if (dicountpercent != 0)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        height: 16,
                        decoration: const BoxDecoration(
                          color: errorColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(defaultBorderRadious)),
                        ),
                        child: Text(
                          "$dicountpercent% off",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        )),
                  )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 13),
                  ),
                  const Spacer(),
                  dicountpercent != 0
                      ? Row(
                          children: [
                            Text(
                              "₫ ${formatPrice(priceAfetDiscount!)}",
                              style: const TextStyle(
                                color: Color(0xFF31B0D8),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            // const SizedBox(width: defaultPadding / 4),
                            // Text(
                            //   "₫ $price",
                            //   style: TextStyle(
                            //     color: Theme.of(context)
                            //         .textTheme
                            //         .bodyMedium!
                            //         .color,
                            //     fontSize: 10,
                            //     decoration: TextDecoration.lineThrough,
                            //   ),
                            // ),
                          ],
                        )
                      : Text(
                          "₫ ${formatPrice(price)}",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
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
}

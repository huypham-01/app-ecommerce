import 'package:flutter/material.dart';

import '../../../../constants.dart';

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    super.key,
    required this.price,
    this.priceAfterDiscount,
  });

  final double price;
  final double? priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Giá tiền",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: defaultPadding / 1),
        Text.rich(
          TextSpan(
            text: priceAfterDiscount == null
                ? "₫ ${formatPrice(price)}  "
                : "₫ ${formatPrice(priceAfterDiscount!)}  ",
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            children: [
              if (priceAfterDiscount != price)
                TextSpan(
                  text: "₫ ${formatPrice(price)}",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      decoration: TextDecoration.lineThrough),
                ),
            ],
          ),
        )
      ],
    );
  }
}

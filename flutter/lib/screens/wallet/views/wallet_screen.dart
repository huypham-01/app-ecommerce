import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';

import '../../../models/review_model.dart';
import 'components/wallet_balance_card.dart';
import 'components/wallet_history_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                sliver: SliverToBoxAdapter(
                  child: WalletBalanceCard(
                    balance: 384.90,
                    onTabChargeBalance: () {},
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: defaultPadding / 2),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Wallet history",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(top: defaultPadding),
                    child: WalletHistoryCard(
                      isReturn: index == 1,
                      date: "JUN 12, 2020",
                      amount: 129,
                      products: [
                        ProductModel(
                          id: 111,
                          image: productDemoImg1,
                          title: "Mountain Warehouse for Women",
                          brandName: "Lipsy london",
                          description: "asfasfasdfasf",
                          price: 540,
                          priceAfetDiscount: 420,
                          dicountpercent: 20,
                          reviews: [
                            ReviewModel(
                              id: 1,
                              userId: 2,
                              rate: 5.0,
                              review: "Sản phẩm rất tuyệt vời, chất lượng tốt!",
                              createdAt: DateTime.parse("2024-10-01 12:00:00"),
                            ),
                          ],
                        ),
                        ProductModel(
                          id: 112,
                          image: productDemoImg4,
                          title: "Mountain Beta Warehouse",
                          description: "asdfasfasf  asfasf",
                          brandName: "Lipsy london",
                          price: 800,
                          reviews: [
                            ReviewModel(
                              id: 1,
                              userId: 2,
                              rate: 5.0,
                              review: "Sản phẩm rất tuyệt vời, chất lượng tốt!",
                              createdAt: DateTime.parse("2024-10-01 12:00:00"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  childCount: 4,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop/test/screens/com/featured_products_section.dart';

class HomeScreenTest extends StatelessWidget {
  const HomeScreenTest({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fashion Store'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BannerSection(),
            // CategorySection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sản phẩm nổi bật",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            PopularProducts(),
          ],
        ),
      ),
    );
  }
}

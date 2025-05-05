import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/screens/search/views/components/search_form.dart';
import 'package:shop/services/categoty_service.dart';

import '../../../components/skleton/others/discover_categories_skelton.dart';
import 'components/expansion_category.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SearchForm(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Danh mục sản phẩm",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            // Sử dụng FutureBuilder để tải danh mục từ API
            Expanded(
              child: FutureBuilder<List<Category>>(
                future: CategoryService().fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Hiển thị khung xương (skeleton) khi đang tải
                    return const DiscoverCategoriesSkelton();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi khi tải danh mục sản phẩm'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có danh mục nào.'));
                  } else {
                    final categories = snapshot.data!
                        .where((category) => category.isParent == 1)
                        .toList();
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) => ExpansionCategory(
                        svgSrc: categories[index].svgSrc ?? "",
                        title: categories[index].title,
                        subCategory: categories[index].children,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

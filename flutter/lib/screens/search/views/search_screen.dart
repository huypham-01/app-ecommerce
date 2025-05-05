import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/components/product/product_card.dart';
import 'dart:convert';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart'; // Đảm bảo import model

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;

  // Hàm tìm kiếm sản phẩm từ API
  Future<void> _searchProducts() async {
    final String keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Gửi yêu cầu tìm kiếm đến backend
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/search?keyword=$keyword'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Chuyển dữ liệu JSON thành các đối tượng Product
      setState(() {
        _searchResults = data.map((json) => Product.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi khi tìm kiếm")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Nhập từ khóa tìm kiếm',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchProducts, // Gọi hàm tìm kiếm
                  ),
                ),
              ),
            ),
            // Nếu đang tải dữ liệu, hiển thị loading
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty)
              Expanded(
                child: Center(
                  child: Text("Không có kết quả tìm kiếm"),
                ),
              )
            else
              // Nếu có kết quả tìm kiếm, hiển thị dưới dạng lưới sản phẩm
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.66,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final product = _searchResults[index];
                            return ProductCard(
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
                            );
                          },
                          childCount: _searchResults.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

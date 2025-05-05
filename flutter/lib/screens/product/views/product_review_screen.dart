import 'package:flutter/material.dart';
import 'package:shop/services/productReview_service.dart';
import 'package:shop/services/user_servece.dart';

class ProductReviewScreen extends StatefulWidget {
  final int productId;
  const ProductReviewScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductReviewScreenState createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 1; // Đánh giá mặc định là 1

  // Phương thức gửi đánh giá
  void _submitReview() async {
    final review = _reviewController.text;
    if (_rating < 1 || _rating > 5 || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đánh giá hợp lệ!')),
      );
      return;
    }
    final response = await ProductReviewService().submitReview(
      widget.productId,
      _rating,
      review,
    );

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá của bạn đã được gửi thành công')),
      );
      Navigator.pop(context); // Quay lại trang trước
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi đánh giá')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đánh giá của bạn:'),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Nhập đánh giá của bạn',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Gửi Đánh Giá'),
            ),
          ],
        ),
      ),
    );
  }
}

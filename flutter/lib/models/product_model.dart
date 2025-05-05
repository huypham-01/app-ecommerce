// For demo only
import 'package:shop/constants.dart';
import 'package:shop/models/review_model.dart';

class ProductModel {
  final int id;
  final String brandName, title, description;
  final String image;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final List<ReviewModel> reviews;

  ProductModel({
    required this.id,
    required this.image,
    required this.brandName,
    required this.description,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.reviews,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      image: json['photo'], // Chuyển đổi chuỗi thành danh sách ảnh
      price: json['price'].toDouble(),
      description: json['description'],
      dicountpercent: json['discount'],
      brandName: json['brand']['title'],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((review) => ReviewModel.fromJson(review))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'discount': dicountpercent,
      'brandName': brandName,
      'review': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

////////////////////////////////
class Product {
  final int id;
  final String brandName, title, description, condition;
  final String image;
  final double price;
  final double? priceAfetDiscount;
  final int? discount;
  final int stock;
  final List<String> size;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.image,
    required this.brandName,
    required this.condition,
    required this.description,
    required this.title,
    required this.price,
    required this.priceAfetDiscount,
    required this.stock,
    this.discount,
    required this.size,
    required this.reviews,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
  double price = (json['price'] ?? 0).toDouble();
  int? discount = json['discount'] != null ? json['discount'] : null;

  // Tính toán giá sau khi giảm giá
  double priceAfterDiscount = discount != null ? price * (1 - discount / 100) : price;
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['photo'], // Chuyển đổi chuỗi thành danh sách ảnh
      price: price,
      discount: discount,
      priceAfetDiscount: priceAfterDiscount,
      size: (json['size'] as String).split(','), // Convert size to List<String>,
      description: json['description'],
      condition: json['condition'] ?? 'N/A',
      stock: json['stock'] ?? 0,
      brandName: json['brand']['title'],
      reviews: (json['get_review'] as List<dynamic>?)
              ?.map((review) => Review.fromJson(review))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'condition': condition,
      'image': image,
      'price': price,
      'size': size,
      'discount': discount,
      'brandName': brandName,
      'review': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    id: 1,
    image: productDemoImg1,
    title: "Mountain Warehouse for Women",
    description: 'teraer',
    brandName: "Lipsy london",
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
    id: 2,
    description: "asdfasfgaasg",
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
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
  ProductModel(
    id: 3,
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
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
    id: 4,
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
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
    id: 5,
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
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
    id: 6,
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    description: "sdfasfasfasf",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
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
];
List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    id: 7,
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
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
    id: 8,
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
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
    id: 9,
    image: productDemoImg4,
    title: "aaaaaaaaa",
    brandName: "Lipsy london",
    description: "Lipsy londonasdfasdf",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
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
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    id: 10,
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "huyhuy huiy áo",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
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
    id: 11,
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
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
    id: 12,
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    description: "Mountain Betaasfasdf",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
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
];
List<ProductModel> kidsProducts = [
  ProductModel(
    id: 13,
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    description: "asdfasfgaasg",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 590.36,
    dicountpercent: 24,
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
];

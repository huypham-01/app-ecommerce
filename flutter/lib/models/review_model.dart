// ignore_for_file: public_member_api_docs, sort_constructors_first


class ReviewModel{
  final int id;
  final int userId;
  final double rate;
  final String review;
  final DateTime createdAt;
  

  ReviewModel({
    required this.id,
    required this.userId,
    required this.rate,
    required this.review,
    required this.createdAt,
  });


  // factory Review.fromJson(Map<String, dynamic> json) {
  //   return Review(
  //     id: json['id'],
  //     userId: json['user_id'],
  //     rate: json['rate'].toDouble(),
  //     review: json['review'],
  //     createdAt: DateTime.parse(json['created_at']),
  //   );
  // }
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      rate: json['rating'].toDouble(),
      review: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userId,
      'rating': rate,
      'comment': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }

}

class Review {
  final int id;
  final int userId;
  final int productId;
  final double rate;
  final String review;
  final String userName;
  final String userPhoto;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rate,
    required this.review,
    required this.userName,
    required this.userPhoto,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(), // Đảm bảo rate không bao giờ null
      review: json['review'] ?? 'No review', // Đảm bảo review không null
      userName: json['user_info']?['name'] ??
          'Unknown User', // Đảm bảo userName không null
      userPhoto:
          json['user_info']?['photo'] ?? '', // Đảm bảo userPhoto không null
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'rating': rate,
      'review': review,
      'createdAt': createdAt,
    };
  }
}


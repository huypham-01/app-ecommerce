// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderItem {
  final int id;
  final int productId;
  final String orderNumber;
  String status;
  final double totalAmount;
  final double price;
  final String image;
  final String title;
  final String size;
  final int quantity;
  OrderItem({
    required this.id,
    required this.productId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.price,
    required this.image,
    required this.title,
    required this.size,
    required this.quantity,
  });
  // Phương thức từ JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['order']['id'],
      productId: json['product']['id'],
      orderNumber: json['order']['order_number'],
      status: json['order']['status'],
      totalAmount: json['order']['total_amount'].toDouble(),
      title: json['product']['title'],
      image: json['product']['photo'],
      size: json['size'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}

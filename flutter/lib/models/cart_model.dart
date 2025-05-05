class CartItem {
  final int id; // ID của sản phẩm trong giỏ hàng (cart_id)
  final int productId; // ID của sản phẩm (product_id)
  final String title;
  final String image;
  final double price;
  int quantity;
  final int stock; // Số lượng còn trong kho
  final String size;
  bool isSelected;

  CartItem({
    required this.id,
    required this.productId, // Bổ sung productId
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.stock,
    required this.size,
    this.isSelected = false, // Mặc định chưa được chọn
  });

  // Tạo đối tượng CartItem từ JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'], // ID của cart
      productId: json['product']['id'], // ID của sản phẩm
      title: json['product']['title'] ?? 'Không có tiêu đề', // Xử lý null
      image: json['product']['photo'] ??
          'https://i.imgur.com/CGCyp1d.png', // Xử lý null
      price: (json['price'] ?? 0).toDouble(), // Xử lý null
      quantity: json['quantity'] ?? 1, // Giá trị mặc định là 1
      size: json['size'] ?? 'N/A', // Giá trị mặc định
      isSelected: json['isSelected'] ?? false,
      stock: json['product']['stock'] ?? 0, // Giá trị mặc định nếu null
    );
  }

  // Chuyển đối tượng CartItem thành JSON (sử dụng khi gửi dữ liệu)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ID của cart
      'product_id': productId, // ID của sản phẩm
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'stock': stock,
      // Không gửi isSelected lên server vì không cần thiết
    };
  }
}

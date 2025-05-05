class User {
  final int id;
  final String name;
  final String email;
  final String photo;
  final String role;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.role,
    required this.status,
  });

  // Hàm khởi tạo từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      role: json['role'],
      status: json['status'],
    );
  }
}

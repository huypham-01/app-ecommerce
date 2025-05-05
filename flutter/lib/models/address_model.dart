class Address {
  final int id;
  final String name;
  final String phone;
  final String province;
  final String district;
  final String ward;
  final String street;
  final String? type;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.street,
    this.type,
    required this.isDefault,
  });

  String get fullAddress => '$street, $ward, $district, $province';

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
      street: json['street'],
      type: json['address_type'],
      isDefault: json['is_default'] == 1,
    );
  }
}

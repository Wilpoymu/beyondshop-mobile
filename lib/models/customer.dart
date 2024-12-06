class Customer {
  final String id;
  final int? document;
  final String name;
  final String address;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    this.document,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      document: json['document'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

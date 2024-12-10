class Product {
  final String? id;
  final String name;
  final double price;

  Product({
    this.id, // Make id optional
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', // Ensure the correct key is used for the id and handle null values
      name: json['name'] ?? '',
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      '_id': id,
      'name': name,
      'price': price,
    };
  }
}
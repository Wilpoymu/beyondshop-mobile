import 'product.dart' as product_model; // Use alias for product

class Order {
  final String id;
  final Client clientId;
  final double totalPrice;
  final List<ProductDetail> productsDetails;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.clientId,
    required this.totalPrice,
    required this.productsDetails,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      clientId: Client.fromJson(json['clientId']),
      totalPrice: json['totalPrice'].toDouble(),
      productsDetails: (json['productsDetails'] as List)
          .map((i) => ProductDetail.fromJson(i))
          .toList(),
      orderDate: DateTime.parse(json['orderDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Client {
  final String id;
  final int document;
  final String name;
  final String address;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    required this.document,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
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

class ProductDetail {
  final product_model.Product? productId; // Use alias for product
  final int quantity;
  final double price;
  final double unitPrice;
  final String id;

  ProductDetail({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.unitPrice,
    required this.id,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productId: json['productId'] != null
          ? product_model.Product.fromJson(json['productId'])
          : null,
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      unitPrice: json['unitPrice'].toDouble(),
      id: json['_id'],
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

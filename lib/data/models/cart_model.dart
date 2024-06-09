import 'dart:convert';

class CartItem {
  final int id;
  final bool deleted;
  final DateTime created;
  final ProductCart product;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.deleted,
    required this.created,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      product: ProductCart.fromJson(json['product']),
      quantity: json['quantity'],
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}

class ProductCart {
  final int id;
  final bool deleted;
  final DateTime created;
  final String name;
  final String description;
  final double price;
  final bool active;
  final int quantity;
  final CategoryCart category;

  ProductCart({
    required this.id,
    required this.deleted,
    required this.created,
    required this.name,
    required this.description,
    required this.price,
    required this.active,
    required this.quantity,
    required this.category,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) {
    return ProductCart(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      active: json['active'],
      quantity: json['quantity'],
      category: CategoryCart.fromJson(json['category']),
    );
  }
}

class CategoryCart {
  final int id;
  final bool deleted;
  final DateTime created;
  final String name;
  final String? description;

  CategoryCart({
    required this.id,
    required this.deleted,
    required this.created,
    required this.name,
    this.description,
  });

  factory CategoryCart.fromJson(Map<String, dynamic> json) {
    return CategoryCart(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      name: json['name'],
      description: json['description'],
    );
  }
}
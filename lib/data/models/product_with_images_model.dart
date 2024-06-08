import 'dart:typed_data';

class ProductWithImages {
  final int id;
  final String name;
  final String? description;
  final double price;
  final bool active;
  final int quantity;
  final dynamic categoryName;
  final dynamic categoryId;
  final List<Uint8List> images;

  ProductWithImages({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.active,
    required this.quantity,
    required this.categoryName,
    required this.categoryId,
    required this.images,
  });

  factory ProductWithImages.fromJson(Map<String, dynamic> json, List<Uint8List> images) {
    return ProductWithImages(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      active: json['active'],
      quantity: json['quantity'],
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      images: images,
    );
  }
}

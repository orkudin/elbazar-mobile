class Category {
  final int id;
  final String name;
  final List<Category> childCategories;

  Category({
    required this.id,
    required this.name,
    this.childCategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      childCategories: (json['childCategories'] as List<dynamic>?)
              ?.map((child) => Category.fromJson(child))
              .toList() ??
          [],
    );
  }
}

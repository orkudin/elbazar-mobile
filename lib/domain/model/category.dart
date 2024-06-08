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

  int? getIdFromName(String name) {
    if (this.name == name) {
      return id;
    }
    for (var childCategory in childCategories) {
      final childId = childCategory.getIdFromName(name);
      if (childId != null) {
        return childId;
      }
    }
    return null;
  }

  /// Gets the name of a category with the given ID within this category or its descendants.
  /// Returns an empty string "" if no matching category is found.
  String getNameFromId(int id) {
    if (this.id == id) {
      return name;
    }
    for (var childCategory in childCategories) {
      final childName = childCategory.getNameFromId(id);
      if (childName.isNotEmpty) {
        return childName;
      }
    }
    return '';
  }
}

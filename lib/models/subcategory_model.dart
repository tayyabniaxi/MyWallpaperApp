class Subcategory {
  final String category;
  final String subcategory;
  final int id;
  final List<String> images;

  Subcategory({
    required this.category,
    required this.subcategory,
    required this.id,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'subcategory': subcategory,
      'id': id,
      'images': images,
    };
  }

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      id: map['id'] ?? -1,
      images: List<String>.from(map['images'] ?? []),
    );
  }
}

class Category {
  final String name;
  final List<Subcategory> subcategories;

  Category({
    required this.name,
    required this.subcategories,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subcategories': subcategories.map((subcategory) => subcategory.toMap()).toList(),
    };
  }
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      subcategories: (map['subcategories'] as List<dynamic>)
          .map((subcategoryMap) => Subcategory.fromMap(subcategoryMap))
          .toList(),
    );
  }
}

class Subcategory {
  final String category;
  final String subcategory;
  final int id; // Ensure id is an int
  final List<String> images;

  Subcategory({
    required this.category,
    required this.subcategory,
    required this.id,
    required this.images,
  });

  // Convert the Subcategory instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'subcategory': subcategory,
      'id': id,
      'images': images,
    };
  }

  // Create a Subcategory instance from a Map
  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      category: map['category'],
      subcategory: map['subcategory'],
      id: map['id'] ?? -1,
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
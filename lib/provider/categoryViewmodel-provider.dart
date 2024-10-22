import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final List<String> categories = [
    'Wallpaper',
    'Technology',
    'Animals',
    'Sports',
    'Art',
    'Food',
  ];

  final Map<String, List<String>> subCategories = {
    'Technology': [
      'AI', 'Gadgets', 'Robots', 'Coding', 'VR', 'AR', 'Blockchain', 'Drones',
    ],
    'Animals': [
      'Cats', 'Dogs', 'Birds', 'Wildlife', 'Aquatic', 'Insects', 'Pets', 'Horses',
    ],
    'Sports': [
      'Football', 'Basketball', 'Tennis', 'Swimming', 'Running', 'Cycling', 'Baseball', 'Boxing',
    ],
    'Art': [
      'Painting', 'Photography', 'Design', 'Fashion', 'Digital Art', 'Calligraphy', 'Illustration', 'Typography'
    ],
    'Food': [
      'Fruits', 'Fast Food', 'Desserts', 'Drinks', 'Seafood', 'Meat', 'Baking', 'Dairy'
    ],
  };

  String _selectedCategory = 'Technology';
  int _itemsPerPage = 3;
  int _currentPage = 0;
  List<String> _displayedSubCategories = [];

  String get selectedCategory => _selectedCategory;
  List<String> get displayedSubCategories => _displayedSubCategories;

  void loadSubCategories(String category) {
    _selectedCategory = category;
    _currentPage = 0;
    _displayedSubCategories = [];
    loadMoreItems();
    notifyListeners();  // Notify listeners to update UI
  }

  void loadMoreItems() {
    if (_currentPage * _itemsPerPage >= subCategories[_selectedCategory]!.length) {
      return;  // No more items to load
    }

    final endIndex = (_currentPage + 1) * _itemsPerPage;
    _displayedSubCategories.addAll(subCategories[_selectedCategory]!.sublist(
      _currentPage * _itemsPerPage,
      endIndex > subCategories[_selectedCategory]!.length
          ? subCategories[_selectedCategory]!.length
          : endIndex,
    ));
    _currentPage++;
    notifyListeners();  // Notify listeners to update UI
  }
}

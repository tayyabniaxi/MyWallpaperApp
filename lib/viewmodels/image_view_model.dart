// lib/viewmodels/image_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/image_model.dart';

class ImageViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<String, List<ImageModel>> _cachedImages = {};
  List<ImageModel> _images = [];
  String _selectedCategory = 'Popular';

  List<ImageModel> get images => _images;
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
    fetchImages();
  }

  Future<void> fetchImages() async {
    if (_cachedImages.containsKey(_selectedCategory)) {
      _images = _cachedImages[_selectedCategory]!;
      notifyListeners();
      return;
    }

    final doc = await firestore.collection('categories').doc(_selectedCategory).get();
    if (doc.exists) {
      final imageUrls = List<String>.from(doc['images'] ?? []);
      _images = imageUrls.map((url) => ImageModel(url: url)).toList();
      _cachedImages[_selectedCategory] = _images;
    } else {
      _images = [];
    }
    notifyListeners();
  }
}

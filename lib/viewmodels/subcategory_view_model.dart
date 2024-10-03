import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class SubcategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  List<String> _imageUrls = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 0;
  static const int _pageSize = 5; // Adjust the page size as needed

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch images based on page
  Future<void> fetchSubcategoryImages(String categoryId, String subcategoryId) async {
    if (_isLoading) return; // Prevent multiple calls

    _setLoading(true);
    clearError();

    try {
      DocumentSnapshot<Map<String, dynamic>> document =
      await _db.collection('categories').doc(categoryId).collection('subcategories').doc(subcategoryId).get();

      if (document.exists) {
        List<String> allImages = List<String>.from(document.data()?['images'] ?? []);
        _loadNextChunk(allImages);
      } else {
        _setError('Subcategory not found');
      }
    } catch (e) {
      _setError('Error fetching subcategory images: ${e.toString()}');
      _logger.e('Error fetching subcategory images: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _loadNextChunk(List<String> allImages) {
    if (_currentPage * _pageSize < allImages.length) {
      int startIndex = _currentPage * _pageSize;
      int endIndex = startIndex + _pageSize;
      _imageUrls.addAll(allImages.sublist(startIndex, endIndex > allImages.length ? allImages.length : endIndex));
      _currentPage++;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

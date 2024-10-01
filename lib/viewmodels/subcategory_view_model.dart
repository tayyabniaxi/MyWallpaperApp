import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class SubcategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  List<String> _imageUrls = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch images directly from the Firestore subcategory document
  Future<void> fetchSubcategoryImages(String categoryId, String subcategoryId) async {
    _setLoading(true);
    clearError();

    try {
      DocumentSnapshot<Map<String, dynamic>> document =
      await _db.collection('categories').doc(categoryId).collection('subcategories').doc(subcategoryId).get();

      if (document.exists) {
        _imageUrls = List<String>.from(document.data()?['images'] ?? []);
        if (_imageUrls.isEmpty) {
          _setError('No images available for $subcategoryId.');
        }
        _logger.i('Subcategory images fetched for: $subcategoryId in $categoryId');
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
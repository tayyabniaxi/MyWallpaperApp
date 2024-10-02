import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/full_screen_image_page.dart';
import 'dart:async';  // For debounce functionality

class SubcategoryPage extends StatefulWidget {
  final String category;
  final String subcategory;

  SubcategoryPage({
    required this.category,
    required this.subcategory, required List imageUrls, required List isFavoriteList,
  });

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<String> _imageUrls = [];
  List<bool> _isFavoriteList = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _lastDocumentId;  // For pagination
  Timer? _debounce;  // For debounce functionality
  final int _pageSize = 10;  // Limit of images to load per page

  @override
  void initState() {
    super.initState();
    fetchImages();  // Load initial batch of images
  }

  // Fetch images with pagination and limit
  Future<void> fetchImages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Query<Map<String, dynamic>> query = _db
          .collection('categories')
          .doc(widget.category)
          .collection('subcategories')
          .doc(widget.subcategory)
          .collection('images')
          .limit(_pageSize);

      if (_lastDocumentId != null) {
        query = query.startAfter([_lastDocumentId]);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocumentId = snapshot.docs.last.id;  // Store last document for next fetch
        List<String> newImageUrls = snapshot.docs.map((doc) => doc['url'].toString()).toList();

        // Update the image list and favorite status
        setState(() {
          _imageUrls.addAll(newImageUrls);
          _isFavoriteList.addAll(List<bool>.filled(newImageUrls.length, false));  // Update favorite list with false by default
        });
      } else {
        setState(() {
          _errorMessage = 'No more images available.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching images: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _isImageFavorite(String url) async {
    final favRef = _db.collection('userFavorites').where('url', isEqualTo: url);
    final snapshot = await favRef.get();
    return snapshot.docs.isNotEmpty;
  }

  void toggleFavorite(int index) async {
    final imageUrl = _imageUrls[index];
    if (_isFavoriteList[index]) {
      await _db.collection('userFavorites').where('url', isEqualTo: imageUrl).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } else {
      await _db.collection('userFavorites').add({'url': imageUrl});
    }

    setState(() {
      _isFavoriteList[index] = !_isFavoriteList[index];
    });
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isLoading && _errorMessage == null) {
        fetchImages();  // Fetch more images when scrolling stops
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategory)),
      body: _isLoading && _imageUrls.isEmpty
          ? Center(child: CircularProgressIndicator())  // Show loading if fetching first batch of images
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _onScroll();  // Trigger debounce on reaching the end of the scroll
          }
          return true;
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      imageUrl: _imageUrls[index],
                      isFavorite: _isFavoriteList[index],
                      onFavoriteToggle: () => toggleFavorite(index),
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: _imageUrls[index],
                fit: BoxFit.cover,
                memCacheWidth: 300,  // Reduce cache size for better performance
                memCacheHeight: 300,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();  // Cancel debounce timer when disposing
    super.dispose();
  }
}

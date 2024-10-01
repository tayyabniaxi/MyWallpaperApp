import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/full_screen_image_page.dart';

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

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final doc = await _db
          .collection('categories')
          .doc(widget.category)
          .collection('subcategories')
          .doc(widget.subcategory)
          .get();

      if (doc.exists) {
        _imageUrls = List<String>.from(doc.data()?['images'] ?? []);
        _isFavoriteList = await Future.wait(_imageUrls.map((url) => _isImageFavorite(url)));
      } else {
        _errorMessage = 'No images found for this subcategory.';
      }
    } catch (e) {
      _errorMessage = 'Error fetching images: $e';
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategory)),
      body: GridView.builder(
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
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}
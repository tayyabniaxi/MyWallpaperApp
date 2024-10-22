//
// Import necessary packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:my_wallpaper_app/widgets/full_screen_image_page.dart';

class SearchImagePage extends StatefulWidget {
  @override
  _SearchImagePageState createState() => _SearchImagePageState();
}

class _SearchImagePageState extends State<SearchImagePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _suggestedImages = [];
  bool isPro=false;
  bool _showSuggestions = false;

  Future<List<Map<String, dynamic>>> _searchImages(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('images') // Your collection name
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff') // Range query
          .get();

      return querySnapshot.docs.map((doc) => {
        'name': doc['name'],
        'url': doc['url'],
        'isPro': doc['isPro'], // Include isPro in the result
      }).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error searching images: $e');
      return [];
    }
  }
  // Future<List<Map<String, dynamic>>> _searchImages(String query) async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('images')
  //         .where('name', isGreaterThanOrEqualTo: query)
  //         .where('name', isLessThanOrEqualTo: '$query\uf8ff') // Range query
  //         .get();
  //
  //     return querySnapshot.docs
  //         .map((doc) => {
  //       'name': doc['name'],
  //       'url': doc['url'],
  //     })
  //         .toList();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error searching images: $e');
  //     return [];
  //   }
  // }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> results = await _searchImages(query);
      setState(() {
        _suggestedImages = results;
        _showSuggestions = true; // Show suggestions when typing
      });
    } else {
      setState(() {
        _suggestedImages = [];
        _showSuggestions = false; // Hide suggestions if query is empty
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Page',
          style: TextStyle(fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by image name',
                hintStyle:
                TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text.toLowerCase();
                      _showSuggestions = false; // Hide suggestions on search
                    });
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // StaggeredGridView for showing images based on the search
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _searchImages(_searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final images = snapshot.data ?? [];
              if (images.isEmpty) {
                return Center(child: Text('No images found.'));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.extent(1, index.isEven ? 200 : 300),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemCount: images.length,

                  itemBuilder: (context, index) {
                    final isPro = images[index]['isPro']; // Get isPro value for the current item

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              imageUrl: images[index]['url'],
                              isFavorite: false,
                              onFavoriteToggle: () {},
                              image: [],
                            ),
                          ),
                        );
                      },
                      child: Stack(
alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: images[index]['url'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                           right:0,
                            top:0,
                            child:
                          isPro?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            child: Container(


                                                padding: EdgeInsets.symmetric(vertical: 1,horizontal: 6),
                                                decoration: BoxDecoration(
                                                color: Colors.blue.shade200,
                                                borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                'Pro',
                                                style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                ),
                                                ),
                                                ),
                          ):Container(),)
                        ],
                      ),
                    );
                  },


                ),
              );
            },
          ),

          // Suggestions ListView at the top
          if (_showSuggestions)
            Container(

              margin: EdgeInsets.only(top: 0, left: 8,right: 8), // Adjust margin from the top
              padding: EdgeInsets.symmetric(horizontal: 2,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: _suggestedImages.length,

                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _searchQuery = _suggestedImages[index]['name'];

                        _showSuggestions = false;
                      });
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _suggestedImages[index]['url'],
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(_suggestedImages[index]['name']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

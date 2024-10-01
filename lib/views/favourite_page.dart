import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallpaper_app/assets/app_assets.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';
import '../widgets/full_screen_image_page.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('userFavorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          }

          final favoriteDocs = snapshot.data?.docs ?? [];

          if (favoriteDocs.isEmpty) {
            return Center(
              child: SvgPicture.asset(AppIcons.favouriteNoData),
            );
          }

          final favoriteUrls = favoriteDocs.map((doc) => doc['url'] as String).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: favoriteUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = favoriteUrls[index];

              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            imageUrl: imageUrl,
                            isFavorite: true,
                            onFavoriteToggle: () {},
                          ),
                        ),
                      );
                    },
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        _removeFromFavorites(imageUrl);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
  Future<void> _removeFromFavorites(String url) async {
    final snapshot = await firestore.collection('userFavorites').where('url', isEqualTo: url).get();
    if (snapshot.docs.isNotEmpty) {
      await firestore.collection('userFavorites').doc(snapshot.docs.first.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image removed from favorites')),
      );
    }
  }
}
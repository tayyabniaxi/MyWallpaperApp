
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_wallpaper_app/theme/app_theme.dart';
import '../widgets/full_screen_image_page.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}


class _HomeContentState extends State<HomeContent> {

  String selectedCategory = 'Popular';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, List<String>> cachedImages = {};
  final int pageSize = 4;
  List<String> currentImages = [];
  bool isLoading = false;
  bool hasMore = true;

  Future<void> _fetchCategoryImageUrls(String category, {bool refresh = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      currentImages.clear();
      hasMore = true;
    }

    if (!hasMore) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final doc = await firestore.collection('categories').doc(category).get();
      if (doc.exists) {
        List<String> allImages = List<String>.from(doc['images'] ?? []);
        int startIndex = currentImages.length;
        int endIndex = startIndex + pageSize;
        if (endIndex > allImages.length) {
          endIndex = allImages.length;
          hasMore = false;
        }
        List<String> newImages = allImages.sublist(startIndex, endIndex);
        setState(() {
          currentImages.addAll(newImages);
          isLoading = false;
        });
      } else {
        setState(() {
          hasMore = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _isImageFavorite(String url) async {
    final favRef = firestore.collection('userFavorites').where('url', isEqualTo: url);
    final snapshot = await favRef.get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoryImageUrls(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    Color selectedColor = themeViewModel.isDarkMode ? AppColors.purpleColor : AppColors.purpleColor;
    Color defaultColor = themeViewModel.isDarkMode ? AppColors.lightPurpleColor : AppColors.lightPurpleColor;
    Color wallpaperColor = themeViewModel.isDarkMode ? Colors.white : Colors.black;
    Color wallpaperTextColor = themeViewModel.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      // backgroundColor: Colors.red,
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Wallpaper', 'Popular', 'Nature', 'Random'].map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    if (category != 'Wallpaper' && category != selectedCategory) {
                      setState(() {
                        selectedCategory = category;
                        _fetchCategoryImageUrls(category, refresh: true);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: category == 'Wallpaper' ? wallpaperColor : (isSelected ? selectedColor : defaultColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          category,
                          style: TextStyle(color: isSelected || category == 'Wallpaper' ? wallpaperTextColor : Colors.black),
                        ),
                        if (category == 'Wallpaper') ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _fetchCategoryImageUrls(selectedCategory);
                }
                return true;
              },
              child: GridView.builder(
                
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 0.5,
                ),
                itemCount: currentImages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == currentImages.length) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return 
                  
                  GestureDetector(
                    onTap: () async {
                      bool isFavorite = await _isImageFavorite(currentImages[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            imageUrl: currentImages[index],
                            isFavorite: isFavorite,
                            onFavoriteToggle: () {},
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: currentImages[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  );
              
              
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



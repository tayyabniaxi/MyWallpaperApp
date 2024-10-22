

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_wallpaper_app/theme/app_theme.dart';
import '../utils/app-color.dart';
import '../widgets/full_screen_image_page.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = 'Popular';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, List<String>> cachedImages = {};
  final ScrollController _scrollController = ScrollController();

  List<String> currentImages = [];
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 6;

  @override
  void initState() {
    super.initState();
    _fetchCategoryImageUrls(selectedCategory);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchCategoryImageUrls(String category,
      {bool refresh = false}) async {
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

  void _onScroll() {
    if (!isLoading && _scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      _fetchCategoryImageUrls(selectedCategory);
    }
  }

  Future<bool> _isImageFavorite(String url) async {
    final favRef = firestore.collection('userFavorites').where(
        'url', isEqualTo: url);
    final snapshot = await favRef.get();
    return snapshot.docs.isNotEmpty;
  }



  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);


    Color categoryColor = themeViewModel.isDarkMode ? Color(0xff4C3D90) : Color(0xffE5D7FF);
    Color selectedCategoryColor = themeViewModel.isDarkMode ?Color(0xff7B39FD) : AppColor.categoryLightThemeColorselect ;
    Color subCategoryColor = themeViewModel.isDarkMode ? const Color(0xFF4C3D90)  : Color(0xffF8F5FF);

    Color selectedColor =themeViewModel.isDarkMode ?Color(0xff7B39FD) : AppColor.categoryLightThemeColorselect ;
    Color defaultColor = themeViewModel.isDarkMode ? Color(0xff4C3D90) : Color(0xffE5D7FF);
    Color wallpaperColor = themeViewModel.isDarkMode ? Colors.white : Colors
        .black;
    Color wallpaperTextColor = themeViewModel.isDarkMode ? Colors.black : Colors
        .white;

    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 0.0),
              child: Row(
                children: ['Wallpaper', 'Popular', 'Nature', 'Random'].map((
                    category) {
                  final isSelected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      if (category != 'Wallpaper') {
                        setState(() {
                          selectedCategory = category;
                          _fetchCategoryImageUrls(category, refresh: true);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5,
                          horizontal: 10),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: category == 'Wallpaper'
                            ? wallpaperColor
                            : (isSelected ? selectedColor : defaultColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              color: isSelected || category == 'Wallpaper'
                                  ? wallpaperTextColor
                                  : Colors.black,
                            ),
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
          ),
          const SizedBox(height: 10),

          // Main content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isLoading && currentImages.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading && scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _fetchCategoryImageUrls(selectedCategory);
                  }
                  return true;
                },
                child:

                StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  crossAxisCount: 2,
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
                    return GestureDetector(
                      onTap: () async {
                        bool isFavorite = await _isImageFavorite(
                            currentImages[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImagePage(
                                  imageUrl: currentImages[index],
                                  isFavorite: isFavorite,
                                  onFavoriteToggle: () {},
                                  image: [],
                                ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: currentImages[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                color: Colors.grey[300],
                              ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.extent(
                        1,
                        index.isEven ? 200 : 300,
                      ),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

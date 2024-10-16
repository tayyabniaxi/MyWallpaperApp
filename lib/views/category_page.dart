import 'package:flutter/material.dart';
import 'package:my_wallpaper_app/theme/app_theme.dart';
import 'package:my_wallpaper_app/views/sub_category_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
      'AI',
      'Gadgets',
      'Robots',
      'Coding',
      'VR',
      'AR',
      'Blockchain',
      'Drones',
    ],
    'Animals': [
      'Cats',
      'Dogs',
      'Birds',
      'Wildlife',
      'Aquatic',
      'Insects',
      'Pets',
      'Horses',
    ],
    'Sports': [
      'Football',
      'Basketball',
      'Tennis',
      'Swimming',
      'Running',
      'Cycling',
      'Baseball',
      'Boxing',
    ],
    'Art': [
      'Painting',
      'Photography',
      'Design',
      'Fashion',
      'Digital Art',
      'Calligraphy',
      'Illustration',
      'Typography'
    ],
    'Food': [
      'Fruits',
      'Fast Food',
      'Desserts',
      'Drinks',
      'Seafood',
      'Meat',
      'Baking',
      'Dairy'
    ],
  };

  final Map<String, IconData> subCategoryIcons = {
    'AI': Icons.memory,
    'Gadgets': Icons.devices,
    'Robots': Icons.smart_toy,
    'Coding': Icons.code,
    'VR': Icons.vrpano,
    'AR': Icons.view_in_ar,
    'Blockchain': Icons.lock,
    'Drones': Icons.air,
    'Cats': Icons.pets,
    'Dogs': Icons.pets,
    'Birds': Icons.filter_vintage,
    'Wildlife': Icons.nature,
    'Aquatic': Icons.pool,
    'Insects': Icons.bug_report,
    'Pets': Icons.pets,
    'Horses': Icons.directions_run,
    'Football': Icons.sports_football,
    'Basketball': Icons.sports_basketball,
    'Tennis': Icons.sports_tennis,
    'Swimming': Icons.pool,
    'Running': Icons.directions_run,
    'Cycling': Icons.directions_bike,
    'Baseball': Icons.sports_baseball,
    'Boxing': Icons.sports_mma,
    'Painting': Icons.brush,
    'Photography': Icons.camera_alt,
    'Design': Icons.design_services,
    'Fashion': Icons.checkroom,
    'Digital Art': Icons.computer,
    'Calligraphy': Icons.edit,
    'Illustration': Icons.create,
    'Typography': Icons.font_download,
    'Fruits': Icons.apple,
    'Fast Food': Icons.fastfood,
    'Desserts': Icons.cake,
    'Drinks': Icons.local_drink,
    'Seafood': Icons.set_meal,
    'Meat': Icons.dining,
    'Baking': Icons.kitchen,
    'Dairy': Icons.icecream,
  };

  String selectedCategory = 'Technology';


  final int itemsPerPage = 3; 
  int currentPage = 0; // Current page
  List<String> displayedSubCategories = []; // List to hold currently displayed items
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _loadMoreItems(); // Load the initial items
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _loadMoreItems(); // Load more items when scrolled to the bottom
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    if (currentPage * itemsPerPage >= subCategories[selectedCategory]!.length) {
      return; // No more items to load
    }

    final endIndex = (currentPage + 1) * itemsPerPage;
    displayedSubCategories.addAll(subCategories[selectedCategory]!.sublist(
      currentPage * itemsPerPage,
      endIndex > subCategories[selectedCategory]!.length
          ? subCategories[selectedCategory]!.length
          : endIndex,
    ));
    currentPage++;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    Color categoryColor = themeViewModel.isDarkMode ? const Color(0xFFE5D7FF)  : AppColors.lighterPurpleColor;
    Color selectedCategoryColor = themeViewModel.isDarkMode ? const Color(0xFF7B39FD) : const Color(0xFF7B39FD);
    Color subCategoryColor = themeViewModel.isDarkMode ? const Color(0xFFA375FE)  : Colors.white;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  bool isWallpaper = category == 'Wallpaper';

                  Color bgColor = isWallpaper
                      ? (themeViewModel.isDarkMode ? Colors.white : Colors.black)
                      : (selectedCategory == category ? selectedCategoryColor : categoryColor);
                  Color textColor = isWallpaper
                      ? (themeViewModel.isDarkMode ? Colors.black : Colors.white)
                      : (selectedCategory == category ? Colors.white : Colors.black);

                  return GestureDetector(
                    onTap: () {
                      if (!isWallpaper) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isWallpaper) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: textColor,
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
          if (subCategories.containsKey(selectedCategory))
            Expanded(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: subCategories[selectedCategory]!.take(5).map(
                            (subCategory) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubcategoryPage(
                                  category: selectedCategory,
                                  subcategory: subCategory,
                                  imageUrls: [],
                                  isFavoriteList: [],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: subCategoryColor, // Use theme color
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  subCategoryIcons[subCategory],
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  subCategory,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: subCategories[selectedCategory]!.skip(5).map(
                            (subCategory) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubcategoryPage(
                                  category: selectedCategory,
                                  subcategory: subCategory,
                                  imageUrls: [],
                                  isFavoriteList: [],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: subCategoryColor, // Use theme color
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  subCategoryIcons[subCategory],
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  subCategory,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
      itemCount: displayedSubCategories.length,
                      // itemCount: subCategories[selectedCategory]!.length,
                      itemBuilder: (context, index) {
                        // final subCategory =
                        // subCategories[selectedCategory]![index];
                        final subCategory = displayedSubCategories[index];
                        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subCategory,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoryPage(
                            category: selectedCategory,
                            subcategory: subCategory,
                            imageUrls: [],
                            isFavoriteList: [],
                          ),
                        ),
                      );
                    },
                                    child: const Text('View All',
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 150,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: FutureBuilder<List<String>>(
                                future: _fetchSubcategoryImages(
                                    selectedCategory, subCategory),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                        Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No images available.'));
                                  } else {
                                    final images = snapshot.data!;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, imgIndex) {
                                        return Container(
                                          width: 120,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: CachedNetworkImage(
                                            imageUrl: images[imgIndex],
                                            placeholder: (context, url) => Center(
                                                child:
                                                CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
               
               
                ],
              ),
            ),
        ],
      ),
    );
  }



  Future<List<String>> _fetchSubcategoryImages(
      String category, String subcategory) async {
    final doc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(category)
        .collection('subcategories')
        .doc(subcategory)
        .get();

    if (doc.exists) {
      return List<String>.from(doc.data()?['images'] ?? []);
    }
    return [];
  }
}



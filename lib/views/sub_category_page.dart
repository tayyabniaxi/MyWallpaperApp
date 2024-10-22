

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_wallpaper_app/theme/app_theme.dart';
import 'package:my_wallpaper_app/utils/app-color.dart';
import 'package:my_wallpaper_app/viewmodels/theme_view_model.dart';
import 'package:provider/provider.dart';
import '../viewmodels/subcategory_view_model.dart';
import '../widgets/full_screen_image_page.dart';



class SubcategoryPage extends StatefulWidget {
  final String category;
  final String subcategory;
  final List imageUrls;
  final List isFavoriteList;
  final List<String> subCategories; // List of subcategories
  final bool isViewAll; // New parameter to check if it's 'View All'

  SubcategoryPage({
    required this.category,
    required this.subcategory,
    required this.imageUrls,
    required this.isFavoriteList,
    required this.subCategories,
    this.isViewAll = false, // Default to false
  });

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}
class _SubcategoryPageState extends State<SubcategoryPage> {
  late SubcategoryViewModel _viewModel;
  late String selectedSubcategory;
  late List currentImageUrls;

  // Pagination variables
  int currentPage = 0;
  final int itemsPerPage = 4;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<SubcategoryViewModel>(context, listen: false);
    selectedSubcategory = widget.subcategory;
    currentImageUrls = [];

    // Load initial images
    _loadMoreImages();
  }
  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);


    Color categoryColor = themeViewModel.isDarkMode ? Color(0xff4C3D90) : Color(
        0xffE5D7FF);
    Color selectedCategoryColor = themeViewModel.isDarkMode
        ? Color(0xff7B39FD)
        : AppColor.categoryLightThemeColorselect;
    Color subCategoryColor = themeViewModel.isDarkMode
        ? const Color(0xFF4C3D90)
        : Color(0xffF8F5FF);

    Color topImageCountContainer = themeViewModel.isDarkMode
        ? const Color(0xff32305E)
        : AppColor.lightThemesubCategoryimageCountContainer;

    Color topImageCountContainerText = themeViewModel.isDarkMode
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.category} Category",
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
              color: Theme
                  .of(context)
                  .appBarTheme
                  .foregroundColor),
        ),
      ),
      body: Column(
        children: [
          Container(

            height: MediaQuery
                .of(context)
                .size
                .height * 0.1,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.subCategories.length + 1,
              itemBuilder: (context, index) {

                String subCat;
                if (index == 0) {
                  subCat = widget.category;
                } else {
                  subCat = widget.subCategories[index - 1];
                }

                bool isSelected = subCat == selectedSubcategory;

                return GestureDetector(
                  onTap: () {
                    if (index == 0) return;

                    setState(() {
                      selectedSubcategory = subCat;
                      // Reset pagination variables
                      currentPage = 0;
                      hasMoreData = true;
                      currentImageUrls = [];
                    });

                    // Load new images for the selected subcategory
                    _loadMoreImages();
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4,),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 5),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? themeViewModel.isDarkMode
                              ? Colors.white
                              : Colors.black
                              : (isSelected
                              ? selectedCategoryColor
                              : categoryColor),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          subCat,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == 0
                                ? themeViewModel.isDarkMode
                                ? Colors.black
                                : Colors.white
                                : (isSelected
                                ? (themeViewModel.isDarkMode
                                ? Colors.black
                                : Colors.white)
                                : Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 9,)
                    ],
                  ),
                );
              },
            ),
          ),

          // Subcategory name and image count
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(

                  color: topImageCountContainer,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedSubcategory,
                      style: TextStyle(
                          fontSize: 13, color: topImageCountContainerText),
                    ),
                    Text(
                      "${currentImageUrls.length} images",
                      style: TextStyle(fontSize: 13,
                          color: topImageCountContainerText,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),

          SizedBox(
            height: 10,
          ),

          // Display images in a staggered grid

          Expanded(
            child: Consumer<SubcategoryViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && currentImageUrls.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null) {
                  return Center(child: Text(viewModel.errorMessage!));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoadingMore &&
                        hasMoreData &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      // Load more images when reaching the bottom
                      _loadMoreImages();
                    }
                    return false;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.extent(1, index.isEven ? 200 : 300),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemCount: currentImageUrls.length +
                          (isLoadingMore ? 1 : 0), // Show loading indicator if loading more
                      itemBuilder: (context, index) {
                        if (index == currentImageUrls.length) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: currentImageUrls[index],
                                  isFavorite: false,
                                  onFavoriteToggle: () {},
                                  image: newImages!,
                                  // image: widget.imageUrls,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: currentImageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
  List<String>? newImages;

  Future<void> _loadMoreImages() async {
    if (isLoadingMore || !hasMoreData) return;

    setState(() {
      isLoadingMore = true;
    });

    // Fetch the images from Firestore
    newImages  = await _fetchSubcategoryImages(
        widget.category, selectedSubcategory, currentPage, itemsPerPage);

    setState(() {
      if (newImages?.isEmpty??false) {
        hasMoreData = false; // No more data to load
      } else {
        currentImageUrls.addAll(newImages!); // Add new images to the list
        currentPage++; // Increment the current page
      }
      isLoadingMore = false;
    });
  }


  Future<List<String>> _fetchSubcategoryImages(
      String category, String subcategory, int page, int limit) async {
    // Fetch data from Firestore with pagination
    final doc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(category)
        .collection('subcategories')
        .doc(subcategory)
        .get();

    if (doc.exists) {
      List<dynamic> imagesData = doc.data()?['images'] ?? [];

      int startIndex = page * limit;
      int endIndex = startIndex + limit;

      List<String> newImageUrls = imagesData
          .skip(startIndex)
          .take(limit)
          .where((imageMap) =>
      imageMap is Map<String, dynamic> && imageMap.containsKey('url') && imageMap['url'] is String)
          .map<String>((imageMap) => imageMap['url'] as String)
          .toList();

      return newImageUrls;
    }

    return [];
  }
}



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

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<SubcategoryViewModel>(context, listen: false);
    // Fetch images for the specific subcategory
    _viewModel.fetchSubcategoryImages(widget.category, widget.subcategory);
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);


    Color categoryColor = themeViewModel.isDarkMode ? AppColor.categorydarkThemeColorselect : Color(0xffE5D7FF);
    Color selectedCategoryColor = themeViewModel.isDarkMode ?AppColor.lightunSelect : AppColor.categoryLightThemeColorselect ;
    Color subCategoryColor = themeViewModel.isDarkMode ? const Color(0xFFA375FE)  : Colors.white;
    return Scaffold(
      appBar: AppBar(title:  Text(
        "PixelScape",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor
                ),
      ),),
      body: Column(
        children: [

          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.subCategories.length + 1, // +1 for the category name
              itemBuilder: (context, index) {
                String subCat;
                if (index == 0) {
                  subCat = widget.category; // First item is the category name
                } else {
                  subCat = widget.subCategories[index - 1]; // Adjust index for subcategories
                }

                bool isCategoryName = index == 0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                  decoration: BoxDecoration(
                    color: isCategoryName
                        ? (themeViewModel.isDarkMode ? Colors.white : Colors.black) // Use your existing colors
                        : const Color(0xFFA375FE), // Color for subcategories
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isCategoryName
                      ? Row(
                    children: [
                      Text(
                        subCat,
                        style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeViewModel.isDarkMode ? Colors.black : Colors.white, // Text color for category name
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0), // Space before arrow
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white, // Arrow color
                          size: 16,
                        ),
                      ),
                    ],
                  )
                      : GestureDetector(
                    onTap: () {
                      // Handle subcategory tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoryPage(
                            subCategories: [],
                            isViewAll: false,

                            category: widget.category,
                            subcategory: subCat,
                            imageUrls: [], // Pass the relevant images here
                            isFavoriteList: [],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      subCat,
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeViewModel.isDarkMode ? Colors.black : Colors.white, // Text color for subcategories
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
             decoration: BoxDecoration(
               border: Border.all(color: Color(0xffA375FE) , width: 1),
               color: Color(0xff32305E),
               borderRadius: BorderRadius.circular(20)
             ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                  children: [
                    Text("Robots", style: TextStyle(fontSize: 13 , color: Colors.white),),
                    Text("322 images", style: TextStyle(fontSize: 13 , color: Colors.white),),
                  ],
                ),
              )),

          SizedBox(height: 10,),


          Expanded(
            child: Consumer<SubcategoryViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.imageUrls.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null) {
                  return Center(child: Text(viewModel.errorMessage!));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!viewModel.isLoading &&
                        scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                      _viewModel.fetchSubcategoryImages(
                          widget.category, widget.subcategory);
                    }
                    return false;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      staggeredTileBuilder: (int index) => StaggeredTile.extent(
                        1,
                        index.isEven ? 200 : 300,
                      ),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemCount:
                      viewModel.imageUrls.length + (viewModel.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == viewModel.imageUrls.length) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: viewModel.imageUrls[index],
                                  isFavorite: false,
                                  onFavoriteToggle: () {},
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                              ),
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
}

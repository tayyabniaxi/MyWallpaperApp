

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    return Scaffold(
      appBar: AppBar(title:  Text(
        "PixelScape",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor
                ),
      ),),
      body: Column(
        children: [
          // Horizontal list of subcategories including category name
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.subCategories.length + 1, // Include category name
              itemBuilder: (context, index) {
                String displayName;
                if (index == 0) {
                  displayName = widget.category; // Show category name at first index
                } else {
                  displayName = widget.subCategories[index - 1]; // Adjust index for subcategories
                }

                return GestureDetector(
                  onTap: () {
                    // Handle tap on category or subcategory
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubcategoryPage(
                          category: index == 0 ? widget.category : widget.category,
                          subcategory: displayName,
                          imageUrls: [], // Fetch relevant images here if needed
                          isFavoriteList: [],
                          subCategories: widget.subCategories,
                          isViewAll: index == 0, // Pass whether it's View All
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      displayName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
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

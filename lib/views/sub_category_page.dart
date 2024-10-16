import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../viewmodels/subcategory_view_model.dart';
import '../widgets/full_screen_image_page.dart';

class SubcategoryPage extends StatefulWidget {
  final String category;
  final String subcategory;

  SubcategoryPage({
    required this.category,
    required this.subcategory,
    required List imageUrls,
    required List isFavoriteList,
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
      appBar: AppBar(title: Text(widget.subcategory)),
      body: Consumer<SubcategoryViewModel>(
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
                // Load more images when reaching the bottom for the selected subcategory
                _viewModel.fetchSubcategoryImages(
                    widget.category, widget.subcategory);
              }
              return false;
            },
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
              ),
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
                  child: CachedNetworkImage(
                    imageUrl: viewModel.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

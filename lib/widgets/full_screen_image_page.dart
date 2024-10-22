

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_wallpaper_app/provider/favorite_toggle.dart';
import 'package:my_wallpaper_app/utils/app-text.dart';
import 'package:my_wallpaper_app/viewmodels/theme_view_model.dart';
import 'package:provider/provider.dart';
import '../utils/image_utils.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final List<String> image;

  FullScreenImagePage({
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required  this.image
  });

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    // Initialize _isFavorite with the value passed from the parent widget
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite; // Toggle the local favorite state
    });
    widget.onFavoriteToggle(); // Call the callback to notify the parent widget
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      body: ListView(
        children: [
          // Main Image
          Stack(
            children: [
              SizedBox(
                width: screenSize.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
              // Back Button
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          // Button Overlay
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite Button
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    favoriteProvider.toggleFavorite(widget.imageUrl);
                    ImageUtils.toggleFavorite(context, widget.imageUrl);
                  },
                ),
                // Download Button
                TextButton(
                  onPressed: () async {
                    await ImageUtils.downloadImage(context, widget.imageUrl);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_sharp, color: Colors.black),
                    ],
                  ),
                ),
                // Set Wallpaper Button
                TextButton(
                  onPressed: () async {
                    await ImageUtils.setWallpaper(context, widget.imageUrl);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallpaper, color: Colors.black),
                    ],
                  ),
                ),

              ],
            ),
          ),
          widget.image?.isEmpty??false || widget.image?.length==0 ?Container():   Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppTextFormate(
              size: 0.02,
              title: "More like this",
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(height: 6,),
        // Related Images Grid
        widget.image?.isEmpty??false || widget.image?.length==0 ?Container():  Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10, bottom: 10),
              child: GridView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable internal scrolling

                itemCount: widget.image?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.3,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(

                            imageUrl: widget.image?[index]??"",
                            isFavorite: false,
                            onFavoriteToggle: () {},
                            image: widget.image,

                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.image?[index]??"",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
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


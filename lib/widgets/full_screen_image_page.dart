// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:provider/provider.dart';
// import '../viewmodels/theme_view_model.dart';
// import '../utils/image_utils.dart';

// class FullScreenImagePage extends StatelessWidget {
  // final String imageUrl;
  // final bool isFavorite;
  // final VoidCallback onFavoriteToggle;

  // FullScreenImagePage({
  //   required this.imageUrl,
  //   required this.isFavorite,
  //   required this.onFavoriteToggle,
  // });

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     final themeViewModel = Provider.of<ThemeViewModel>(context);

//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             width: screenSize.width,
//             height: screenSize.height,
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//               placeholder: (context, url) =>
//                   Center(child: CircularProgressIndicator()),
//               errorWidget: (context, url, error) =>
//                   Center(child: Icon(Icons.error)),
//             ),
//           ),
//           // Button Overlay
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               decoration: BoxDecoration(),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Favorite Button
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: isFavorite ? Colors.red : Colors.white,
//                       ),
//                       onPressed: () {
//                         onFavoriteToggle();
//                         ImageUtils.toggleFavorite(context, imageUrl);
//                       },
//                     ),
//                   ),
                
                
//                   SizedBox(width: 25),
//                   Expanded(
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextButton(
//                         onPressed: () async {
//                           await ImageUtils.downloadImage(context, imageUrl);
//                         },
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.download_sharp, color: Colors.white),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 25),
//                   // Set Wallpaper Button
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: TextButton(
//                       onPressed: () async {
//                         await ImageUtils.setWallpaper(context, imageUrl);
//                       },
//                       child: Text('Set as Wallpaper',
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
 
//   }
// }


/*

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_wallpaper_app/provider/favorite_toggle.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';
import '../utils/image_utils.dart';
class FullScreenImagePage extends StatelessWidget {
   final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  FullScreenImagePage({
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
          // Button Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Favorite Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        favoriteProvider.isFavorite(imageUrl)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteProvider.isFavorite(imageUrl)
                            ? Colors.red
                            : Colors.white,
                      ),
                      onPressed: () {
                        favoriteProvider.toggleFavorite(imageUrl);
                        ImageUtils.toggleFavorite(context, imageUrl);
                      },
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await ImageUtils.downloadImage(context, imageUrl);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_sharp, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  // Set Wallpaper Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await ImageUtils.setWallpaper(context, imageUrl);
                      },
                      child: Text('Set as Wallpaper',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_wallpaper_app/provider/favorite_toggle.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';
import '../utils/image_utils.dart';
// import 'path/to/favorite_provider.dart'; // Import the provider

class FullScreenImagePage extends StatelessWidget {
   final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  FullScreenImagePage({
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });
  @override
  Widget build(BuildContext context) {
    print("jjjjjjjjjjjjjjjjjjjjjjjjjjjj:${isFavorite}");
    final screenSize = MediaQuery.of(context).size;
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    // final favoriteProvider = Provider.of<FavoriteProvider>(context);
 final favoriteProvider = Provider.of<FavoriteProvider>(context); // Access the provider

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            ),
          ),
          // Button Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Favorite Button
                Container(
  decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(8),
  ),
  child: IconButton(
    icon: Icon(
      // Check if the image is favorite and set the icon accordingly
      favoriteProvider.isFavorite(imageUrl) 
          ? Icons.favorite  // Filled heart icon for favorite
          : Icons.favorite_border, // Outlined heart icon for not favorite
      color: favoriteProvider.isFavorite(imageUrl) 
          ? Colors.red  // Red color for filled heart
          : Colors.white, // White color for outlined heart
    ),
    onPressed: () {
      // Toggle favorite status
      favoriteProvider.toggleFavorite(imageUrl);
      
      // Additional logic can be handled here, if necessary
      ImageUtils.toggleFavorite(context, imageUrl);
    },
  ),
),

                  SizedBox(width: 25),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await ImageUtils.downloadImage(context, imageUrl);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_sharp, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  // Set Wallpaper Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await ImageUtils.setWallpaper(context, imageUrl);
                      },
                      child: Text('Set as Wallpaper',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

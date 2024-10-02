// lib/widgets/image_tile.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/image_model.dart';

class ImageTile extends StatelessWidget {
  final ImageModel imageModel;

  ImageTile({required this.imageModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle image tap (e.g., navigate to full screen)
      },
      child: CachedNetworkImage(
        imageUrl: imageModel.url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}

// lib/views/home_content.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/image_view_model.dart';
import '../widgets/image_tile.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageViewModel = Provider.of<ImageViewModel>(context);

    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Wallpaper', 'Popular', 'Nature', 'Random'].map((category) {
                final isSelected = category == imageViewModel.selectedCategory;
                return GestureDetector(
                  onTap: () => imageViewModel.setCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(category, style: TextStyle(color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: imageViewModel.fetchImages(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: imageViewModel.images.length,
                  itemBuilder: (context, index) {
                    return ImageTile(imageModel: imageViewModel.images[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

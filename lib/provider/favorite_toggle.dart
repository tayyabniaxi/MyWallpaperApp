import 'package:flutter/foundation.dart';

class FavoriteProvider with ChangeNotifier {
  final Set<String> _favorites = {};

  bool isFavorite(String imageUrl) {
    return _favorites.contains(imageUrl);
  }

  void toggleFavorite(String imageUrl) {
    if (isFavorite(imageUrl)) {
      _favorites.remove(imageUrl);
    } else {
      _favorites.add(imageUrl);
    }
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}

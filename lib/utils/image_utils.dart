import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ImageUtils {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> downloadImage(
      BuildContext context, String imageUrl) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;

        final directory = await getExternalStorageDirectory();
        final picturesDir = Directory('${directory!.path}/Pictures');
        if (!picturesDir.existsSync()) {
          picturesDir.createSync(recursive: true);
        }

        String fileName =
            'downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String filePath = '${picturesDir.path}/$fileName';

        final file = File(filePath);

        await file.writeAsBytes(bytes);

        // save the image to gallery and then show the snackbar
        await Gal.putImage(filePath).then(
          (value) {
            _showSnackbar(context, 'Your image is saved');
          },
        );
      } catch (e) {
        _showSnackbar(context, 'Failed to download image: $e');
      }
    } else {
      _showSnackbar(
          context, 'Storage permission is required to download images');
    }
  }

  static Future<void> toggleFavorite(
      BuildContext context, String imageUrl) async {
    final favRef =
        firestore.collection('userFavorites').where('url', isEqualTo: imageUrl);
    final snapshot = await favRef.get();

    if (snapshot.docs.isEmpty) {
      firestore.collection('userFavorites').add({'url': imageUrl});
      _showSnackbar(context, 'Image added to favorites');
    } else {
      firestore
          .collection('userFavorites')
          .doc(snapshot.docs.first.id)
          .delete();
      _showSnackbar(context, 'Removed from favorites');
    }
  }

  static Future<void> setWallpaper(
      BuildContext context, String imageUrl) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;

        final directory = await getExternalStorageDirectory();
        final picturesDir = Directory(
            '${directory!.parent.parent.parent.parent.path}/Pictures');
        if (!picturesDir.existsSync()) {
          picturesDir.createSync(recursive: true);
        }

        String filePath = '${picturesDir.path}/temp_wallpaper.jpg';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        // Directly set the wallpaper using a platform channel
        _setWallpaperDirectly(context, filePath);
      } catch (e) {
        _showSnackbar(context, 'Failed to set wallpaper: $e');
      }
    } else {
      _showSnackbar(context, 'Storage permission is required to set wallpaper');
    }
  }

  static Future<void> _refreshGallery(String filePath) async {
    if (Platform.isAndroid) {
      try {
        await Process.run('am', [
          'broadcast',
          '-a',
          'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
          '-d',
          'file://$filePath'
        ]);
      } catch (e) {
        print('Error refreshing gallery: $e');
      }
    }
  }

  static void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 75.0),
        backgroundColor: const Color(0xFF7B39FD),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  static void _setWallpaperDirectly(
      BuildContext context, String filePath) async {
    try {
      const methodChannel =
          MethodChannel('com.example.my_wallpaper_app/wallpaper');
      await methodChannel
          .invokeMethod('setWallpaperDirectly', {"filePath": filePath});

      _showSnackbar(context, 'Wallpaper set successfully');
    } catch (e) {
      _showSnackbar(context, 'Failed to set wallpaper: $e');
    }
  }
}

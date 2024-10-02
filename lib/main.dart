import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/subcategory_view_model.dart';
import 'viewmodels/theme_view_model.dart';
import 'viewmodels/image_view_model.dart'; // Import the ImageViewModel
import 'views/home_page.dart';
import 'package:google_api_availability/google_api_availability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());

  await checkGooglePlayServicesAvailability();
}

Future<void> checkGooglePlayServicesAvailability() async {
  GoogleApiAvailability apiAvailability = GoogleApiAvailability.instance;
  final status = await apiAvailability.checkGooglePlayServicesAvailability();

  if (status == GooglePlayServicesAvailability.success) {
    print("Google Play Services is available.");
  } else {
    print("Google Play Services is not available: $status");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeViewModel>(
      create: (context) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return ChangeNotifierProvider<SubcategoryViewModel>(
            create: (context) => SubcategoryViewModel(),
            child: ChangeNotifierProvider<ImageViewModel>( // Add ImageViewModel Provider here
              create: (context) => ImageViewModel(),
              child: MaterialApp(
                title: 'Wallpaper App',
                theme: themeViewModel.currentTheme,
                home: HomePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}

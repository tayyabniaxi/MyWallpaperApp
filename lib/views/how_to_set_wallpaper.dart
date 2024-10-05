import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class HowToSetWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Setting Wallpaper on Your Device\n\n'
            '1. Open the Wallpaper App: Launch the app where you can browse and select your desired wallpapers.\n\n'
            '2. Choose Your Wallpaper: Browse through the available categories or use the search feature to find a specific wallpaper you like. Tap on the wallpaper you wish to use to view it in full screen.\n\n'
            '3. Download the Wallpaper: Once you have selected your desired wallpaper, look for the download icon and tap it. The wallpaper will be saved to your device’s gallery.\n\n'
            '4. Setting the Wallpaper: After downloading, go to your device’s settings. Navigate to Display > Wallpaper. Choose the option to set your wallpaper for the Home Screen, Lock Screen, or Both. Select the downloaded wallpaper from your gallery and confirm your selection.\n\n'
            '5. Enjoy Your New Wallpaper: Exit the settings and enjoy the fresh look of your device with your newly set wallpaper!',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

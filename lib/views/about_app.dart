import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to Our Wallpaper Application!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Our app is designed to enrich your digital experience by providing an extensive collection of stunning wallpapers for personalizing your devices. We offer a diverse range of high-quality images that cater to various tastes and preferences.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Key Features:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "- **Vast Collection**: Browse through a variety of categories, including serene landscapes, vibrant abstracts, and themed collections.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **User-Friendly Interface**: Easily navigate through our app to find the perfect wallpaper that suits your style.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **Seamless Downloading**: Download your favorite wallpapers with just a few taps.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **Personalization**: Set wallpapers for your home screen, lock screen, or both, ensuring your device reflects your unique personality.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **Manage Favorites**: Keep track of your favorite wallpapers for quick access.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Our Mission",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "We are committed to enhancing your device’s aesthetic appeal and functionality while continuously improving our app based on user feedback. Your satisfaction is our priority, and we strive to provide an enjoyable experience.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Thank you for choosing our wallpaper application to beautify your device!",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

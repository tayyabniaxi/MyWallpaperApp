import 'package:flutter/material.dart';

class InviteFriends extends StatelessWidget {
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
                "Invite Your Friends!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Do you love our wallpaper application? Help your friends discover a world of stunning wallpapers by inviting them to download the app!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "How to Invite Friends:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "- **Share via Social Media**: Post about the app on your favorite social media platforms, such as Facebook, Twitter, or Instagram, and encourage your friends to try it out.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **Send a Direct Message**: Use messaging apps like WhatsApp, Messenger, or SMS to send a direct message to your friends with a link to download the app.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "- **Word of Mouth**: Simply tell your friends about the app in person and show them some of your favorite wallpapers!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Thank You!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "We appreciate your support in spreading the word about our app. Together, we can help everyone find the perfect wallpaper for their devices!",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

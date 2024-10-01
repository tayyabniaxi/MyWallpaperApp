import 'package:flutter/material.dart';

class RateApp extends StatelessWidget {
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
                "We Value Your Feedback!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "If you enjoy using our app, please take a moment to rate us. Your feedback helps us improve and provide a better experience for our users.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "How to Rate Us:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. Open the app store on your device (Google Play Store or Apple App Store).\n"
                    "2. Search for our app by name.\n"
                    "3. Scroll down to the 'Ratings and Reviews' section.\n"
                    "4. Tap on the number of stars you wish to give us and write a brief review about your experience.\n"
                    "5. Submit your rating and feedback.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Thank You!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We appreciate your support and feedback. It motivates us to keep improving and delivering the best possible experience for you.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

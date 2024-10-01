import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'how_to_set_wallpaper.dart';
import 'contact_us.dart';
import 'about_app.dart';
import 'invite_friends.dart';
import 'privacy_policy.dart';
import 'rate_app.dart';
import 'terms_of_use.dart';
import '../viewmodels/theme_view_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account Setting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Features',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Theme Mode",
                    style: TextStyle(fontSize: 17),
                  ),
                  CupertinoSwitch(
                    value: themeViewModel.isDarkMode,
                    onChanged: (value) {
                      themeViewModel.toggleTheme();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Instructions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildList(
                items: [
                  {'text': 'How to set Wallpaper', 'screen': HowToSetWallpaper()},
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildList(
                items: [
                  {'text': 'Contact Us', 'screen': ContactUs()},
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Other',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              _buildList(
                items: [
                  {'text': 'About App', 'screen': AboutApp()},
                  {'text': 'Privacy policy', 'screen': PrivacyPolicy()},
                  {'text': 'Terms of use', 'screen': TermsOfUse()},
                  {'text': 'Rate App', 'screen': RateApp()},
                  {'text': 'Invite Friends', 'screen': InviteFriends()},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList({required List<Map<String, dynamic>> items}) {
    return Column(
      children: items.map((item) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item['text']),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomPage(item['text'], item['screen']),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class CustomPage extends StatelessWidget {
  final String title;
  final Widget screen;

  const CustomPage(this.title, this.screen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: screen,
    );
  }
}
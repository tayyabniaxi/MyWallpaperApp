import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallpaper_app/assets/app_assets.dart';
import 'package:my_wallpaper_app/views/home_content.dart';
import 'package:my_wallpaper_app/views/category_page.dart';
import 'package:my_wallpaper_app/views/favourite_page.dart';
import 'package:my_wallpaper_app/views/account_page.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeContent(),
    CategoryPage(),
    FavouritePage(),
    AccountPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final isDarkMode = themeViewModel.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            (isDarkMode ? Colors.black : Colors.white), // Use theme or fallback
        elevation: 0,
        toolbarHeight: 60,
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 15),
          child: Row(
            children: [
             CircleAvatar(
               backgroundImage: AssetImage(AppImages.applogo2),
             ),
              const SizedBox(width: 10),
              Text(
                "PixelScape",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).appBarTheme.foregroundColor ??
                        (isDarkMode ? Colors.white : Colors.black)),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritePage()));
              },
              child: SvgPicture.asset(AppIcons.searchIcon,
                width: 30,
                height: 30,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF7B39FD),
        ),
        unselectedIconTheme: IconThemeData(
          color: isDarkMode ? Colors.grey : Colors.grey,
        ),
        elevation: 0,
        selectedItemColor: isDarkMode ? Colors.white : const Color(0xFF7B39FD),
        unselectedItemColor: isDarkMode ? Colors.grey : Colors.grey,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.homeIcon,
              color: selectedIndex == 0
                  ? (isDarkMode ? Colors.white : const Color(0xFF7B39FD))
                  : (isDarkMode ? Colors.grey : Colors.grey),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.categoryIcon,
              color: selectedIndex == 1
                  ? (isDarkMode ? Colors.white : const Color(0xFF7B39FD))
                  : (isDarkMode ? Colors.grey : Colors.grey),
            ),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.favouriteIcon,
              color: selectedIndex == 2
                  ? (isDarkMode ? Colors.white : const Color(0xFF7B39FD))
                  : (isDarkMode ? Colors.grey : Colors.grey),
            ),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.accountIcon,
              color: selectedIndex == 3
                  ? (isDarkMode ? Colors.white : const Color(0xFF7B39FD))
                  : (isDarkMode ? Colors.grey : Colors.grey),
            ),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
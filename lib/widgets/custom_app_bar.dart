import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_view_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;

  const CustomAppBar({
    required this.title,
    required this.onBackButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackButtonPressed,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: themeViewModel.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: themeViewModel.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
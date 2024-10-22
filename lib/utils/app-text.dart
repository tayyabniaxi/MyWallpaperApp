
import 'package:flutter/material.dart';

class AppTextFormate extends StatelessWidget {
  String title;
  double size;
  FontWeight fontWeight;
  Color? color;

  AppTextFormate({required this.title, required this.size, required this.fontWeight, this.color});



  @override
  Widget build(BuildContext context) {
    return  Text(title, style: TextStyle(fontSize: MediaQuery.of(context).size.height*size,fontWeight: fontWeight),);

  }
}

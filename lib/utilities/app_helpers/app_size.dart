import 'package:flutter/material.dart';

class AppSize{
  static double appWidth(BuildContext context){
     double width = MediaQuery.of(context).size.width;
     return width;
  }
  static double appHeight(BuildContext context){
     double height = MediaQuery.of(context).size.height;
     return height;
  }
}
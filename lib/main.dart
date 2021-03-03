import 'package:flutter/material.dart';
import './utilities/app_helpers/app_controller.dart';
import 'api/api.dart';
import 'main_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppController.strings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainSplashScreen(),
    );
  }
}

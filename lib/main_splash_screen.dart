import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'auth/login.dart';

class MainSplashScreen extends StatefulWidget {
  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(
          imageBackground: AssetImage("assets/images/main_bg.png"),
          image: Image.asset("assets/images/logo_icon.png"),
          photoSize: 120,
          seconds: 3,
          navigateAfterSeconds: LoginPage(),
          backgroundColor: Colors.white,
          title: Text(
            "Welcome To Kulshe App",
            style: TextStyle(fontSize: 30),
          ),
          loaderColor: Colors.red,
          loadingText: Text(
            "© Copy Right 2021",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

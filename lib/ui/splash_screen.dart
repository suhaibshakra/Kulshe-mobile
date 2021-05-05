import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/lang_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'auth/login.dart';
import 'main_bottom_navigation.dart';

class MainSplashScreen extends StatefulWidget {
  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {

  String token;
  String refreshToken;

  getTokens() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      token = _preferences.getString('token');
      refreshToken = _preferences.getString('refresh_token');
      print("TOKEN  :  $token");
    });
  }
  @override
  void initState() {
    getTokens();

    super.initState();
  }

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
          navigateAfterSeconds: token != null?MainBottomNavigation():LoginScreen(),
          backgroundColor: Colors.white,
          title: Text(
            "Welcome To Kulshe",
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

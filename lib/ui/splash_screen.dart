import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/lang_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'auth/login.dart';
import 'main_bottom_navigation.dart';

class MainSplashScreen extends StatefulWidget {
  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen>
    with TickerProviderStateMixin {
  String token;
  String refreshToken;

  Animation animation;
  AnimationController animationController;

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
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.ease);

    animation.addListener(() {
      setState(() {
        // print(animationController.value);
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // animationController.reverse();
        _startApp();
        print('DATA');
      }
    });

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
  _startApp() {
    return token != null ?
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MainBottomNavigation(),),)
          :
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            buildBg(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: Container(
                  height: (animationController.value * 70) + 150,
                  width: (animationController.value * 70) + 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        ("assets/images/logo_icon.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Center(
                child: Text(
                  "أهلا بك في كل شي",
                  style: appStyle(fontWeight: FontWeight.bold,fontSize: 30,color: AppColors.blackColor2),
                ),
              ),
            )
          ],
        ),

        // body: SplashScreen(
        //   imageBackground: AssetImage("assets/images/main_bg.png"),
        //   image: Image.asset("assets/images/logo_icon.png"),
        //   photoSize: 85,
        //   seconds: 22,
        //   navigateAfterSeconds: token != null?MainBottomNavigation():LoginScreen(),
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     "\n\nأهلا بك في كل شي\n\n",
        //     style: appStyle(fontWeight: FontWeight.bold,fontSize: 30,color: AppColors.blackColor2),
        //   ),
        //   loaderColor: Colors.red,
        //   useLoader: false,
        //   loadingText: Text(
        //     "حقوق النشر محفوظة 2021 ©",
        //     //"© Copy Right 2021",
        //     style: appStyle(fontWeight: FontWeight.bold,fontSize: 16),
        //   ),
        // ),
      ),
    );
  }
}

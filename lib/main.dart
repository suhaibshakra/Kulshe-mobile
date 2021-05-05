import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulshe/ui/ads_package/play_video.dart';
import 'package:kulshe/ui/ads_package/uplaod_images.dart';
import 'package:kulshe/ui/auth/social_media/facebook.dart';
import 'package:kulshe/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './services_api/services.dart';
import 'app_helpers/app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown
  ]);
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool decision = prefs.getBool('x');
  // Widget _screen =
  // (decision == false || decision == null) ? PView() : LoginScreen();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future setLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lang", 'ar');
  }
  @override
  void initState() {
    setState(() {
      setLang().then((value){

        SectionServicesNew.getSections();
        CountriesServices.getCountries();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppController.strings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: (_token == '' || _token == null)
      //     ? LoginScreen()
      //     : MainBottomNavigation(),
      // home: AdDetailsScreen(adID: 1656584,slug: 'هونداي-توسان',),
      home: MainSplashScreen(),
    );
  }
}

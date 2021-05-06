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
      home: MainSplashScreen(),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:bmprogresshud/bmprogresshud.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ProgressHud(
//       isGlobalHud: true,
//       child: MaterialApp(
//           home: HomePage()
//       ),
//     );
//   }
// }
//
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   GlobalKey<ProgressHudState> _hudKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("hud demo"),
//       ),
//       body: ProgressHud(
//         key: _hudKey,
//         maximumDismissDuration: Duration(seconds: 2),
//         child: Center(
//           child: Builder(builder: (context) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 RaisedButton(
//                   onPressed: () {
//                     _showLoadingHud(context);
//                   },
//                   child: Text("show loading"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     _showSuccessHud(context);
//                   },
//                   child: Text("show success"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     _showErrorHud(context);
//                   },
//                   child: Text("show error"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     _showProgressHud(context);
//                   },
//                   child: Text("show progress"),
//                 ),
//
//                 Divider(height: 50),
//
//                 RaisedButton(
//                   onPressed: () async {
//                     ProgressHud.showLoading();
//                     await Future.delayed(const Duration(seconds: 1));
//                     ProgressHud.dismiss();
//                   },
//                   child: Text("show global loading"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     ProgressHud.showAndDismiss(ProgressHudType.success, "load success");
//                   },
//                   child: Text("show global success"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     ProgressHud.showAndDismiss(ProgressHudType.error, "load fail");
//                   },
//                   child: Text("show global error"),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     _showProgressHudGlobal();
//                   },
//                   child: Text("show global progress"),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   _showLoadingHud(BuildContext context) async {
//     ProgressHud.of(context).show(ProgressHudType.loading, "loading...");
//     await Future.delayed(const Duration(seconds: 1));
//     _hudKey.currentState?.dismiss();
//   }
//
//   _showSuccessHud(BuildContext context) {
//     ProgressHud.of(context).showAndDismiss(ProgressHudType.success, "load success");
//   }
//
//   _showErrorHud(BuildContext context) {
//     ProgressHud.of(context).showAndDismiss(ProgressHudType.error, "load fail");
//   }
//
//   _showProgressHud(BuildContext context) {
//     var hud = ProgressHud.of(context);
//     hud.show(ProgressHudType.progress, "loading");
//
//     double current = 0;
//     Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
//       current += 1;
//       var progress = current / 100;
//       hud.updateProgress(progress, "loading $current%");
//       if (progress == 1) {
//         hud.showAndDismiss(ProgressHudType.success, "load success");
//         timer.cancel();
//       }
//     });
//   }
//
//   _showProgressHudGlobal() {
//     ProgressHud.show(ProgressHudType.progress, "loading");
//
//     double current = 0;
//     Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
//       current += 1;
//       var progress = current / 100;
//       ProgressHud.updateProgress(progress, "loading $current%");
//       if (progress == 1) {
//         ProgressHud.showAndDismiss(ProgressHudType.success, "load success");
//         timer.cancel();
//       }
//     });
//   }
// }

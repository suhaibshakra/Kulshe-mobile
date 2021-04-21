import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulshe/ui/ads_package/play_video.dart';
import 'package:kulshe/ui/auth/social_media/facebook.dart';
import 'package:kulshe/ui/splash_screen.dart';
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
  @override
  void initState() {
    setState(() {
      SectionServicesNew.getSections();
      CountriesServices.getCountries();
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

// import 'package:flutter/material.dart';
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Checked Listview',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: MyHomePage(title: 'Flutter Checked Listview'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   List<bool> inputs = new List<bool>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       for(int i=0;i<20;i++){
//         inputs.add(false);
//       }
//     });
//   }
//
//   void itemChange(bool val,int index){
//     setState(() {
//       inputs[index] = val;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Checked ListView'),
//       ),
//       body: new ListView.builder(
//           itemCount: inputs.length,
//           itemBuilder: (BuildContext context, int index){
//             return new Card(
//               child: new Container(
//                 padding: new EdgeInsets.all(10.0),
//                 child: new Column(
//                   children: <Widget>[
//                     new CheckboxListTile(
//                         value: inputs[index],
//                         title: new Text('item $index'),
//                         controlAffinity: ListTileControlAffinity.leading,
//                         onChanged:(bool val){itemChange(val, index);}
//                     )
//                   ],
//                 ),
//               ),
//             );
//
//           }
//       ),
//     );
//   }
// }

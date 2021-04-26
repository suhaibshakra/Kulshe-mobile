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
// class MyPets extends StatefulWidget {
//   @override
//   _MyPetsState createState() => _MyPetsState();
// }
//
// class _MyPetsState extends State<MyPets> {
//   List<Widget> _children = [];
//   List<TextEditingController> controllers = [];  //the controllers list
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Title"),
//         actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: _add)],
//       ),
//       body: ListView(children: _children),
//     );
//   }
//
//   void _add() {
//     TextEditingController controller = TextEditingController();
//     controllers.add(controller);      //adding the current controller to the list
//     for(int i = 0; i < controllers.length; i++){
//       print(controllers[i].text);     //printing the values to show that it's working
//     }
//    }
//
//   @override
//   void dispose() {
//     controllers.clear();
//     super.dispose();
//   }
//
// }



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
//  import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//             primarySwatch: Colors.blue,
//             visualDensity: VisualDensity.adaptivePlatformDensity),
//         home: MyHomePage());
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Problem> problemList = List();
//   final List<TextEditingController> _controllers = List();
//
//   @override
//   void initState() {
//     super.initState();
//
//     problemList.add(Problem(id: '1', problemName: 'Display'));
//     problemList.add(Problem(id: '2', problemName: 'Bluetooth'));
//     problemList.add(Problem(id: '3', problemName: 'Speaker'));
//     problemList.add(Problem(id: '4', problemName: 'PCB'));
//     problemList.add(Problem(id: '5', problemName: 'Camera'));
//     problemList.add(Problem(id: '6', problemName: 'Glass'));
//     problemList.add(Problem(id: '7', problemName: 'Press button'));
//     problemList.add(Problem(id: '8', problemName: 'Charging'));
//     problemList.add(Problem(id: '9', problemName: 'Battery'));
//     problemList.add(Problem(id: '10', problemName: 'Storage'));
//     problemList.add(Problem(id: '11', problemName: 'Overheating'));
//     problemList.add(Problem(id: '12', problemName: 'Restart Problem'));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text('ListView Dynamic Create TextField')),
//         body: _bodyList(problemList));
//   }
//
//   _bodyList(List<Problem> problemList) => ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       itemCount: problemList.length,
//       shrinkWrap: true,
//       itemBuilder: (BuildContext context, int index) {
//         // _controllers.add(new TextEditingController());
//         // _controllers[index].text = problemList[index].enterValue;
//
//         return Container(
//             padding: EdgeInsets.only(top: 0, right: 10, left: 10),
//             child: Row(children: <Widget>[
//               expandStyle(
//                   1,
//                   Container(
//                       margin: EdgeInsets.only(top: 35),
//                       child: Text(problemList[index].problemName))),
//               expandStyle(
//                   2,
//                   TextFormField(
//                       controller: TextEditingController.fromValue(
//                           TextEditingValue(
//                               text: problemList[index].enterValue,
//                               )),
//                       keyboardType: TextInputType.number,
//                       onChanged: (String str) {
//                         problemList[index].enterValue = str;
//                         var total = problemList.fold(
//                             0,
//                                 (t, e) =>t +
//                                 double.parse(
//                                     e.enterValue.isEmpty ? '0' : e.enterValue));
//                         print(total);
//                       }))
//             ]));
//       });
// }
//
// expandStyle(int flex, Widget child) => Expanded(flex: flex, child: child);
//
// class Problem {
//   String id;
//   String problemName;
//
//   String enterValue;
//
//   Problem({this.id, this.problemName, this.enterValue = ''});
//
//   Problem.fromJson(Map<String, dynamic> json) {
//     id = json['ID'];
//     problemName = json['DISPNAME'];
//   }
//
//   Problem copyWith({double enterValue}) {
//     return Problem(
//       enterValue: enterValue ?? this.enterValue,
//     );
//   }
// }
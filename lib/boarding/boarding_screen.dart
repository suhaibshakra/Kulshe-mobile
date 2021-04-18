import 'dart:async';

import 'package:flutter/material.dart';

//model
class Data {
  final String title;
  final String description;
  final String imageUrl;
  final IconData iconData;

  Data(
      {@required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.iconData});
}

class PView extends StatefulWidget {
  @override
  _PViewState createState() => _PViewState();
}

class _PViewState extends State<PView> {
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  final List<Data> myData = [
    Data(
      title: "Title 1",
      description: "Start Activity First Title",
      imageUrl: "assets/images/q1.jpg",
      iconData: Icons.add_box,
    ),
    Data(
      title: "Title 2",
      description: "Next Step Start Activity Second Title",
      imageUrl: "assets/images/q2.jpg",
      iconData: Icons.add_box,
    ),
    Data(
      title: "Title 3",
      description: "Another Next Start Activity Third Title",
      imageUrl: "assets/images/q3.jpg",
      iconData: Icons.add_box,
    ),
    Data(
      title: "Title 4",
      description: "Last Step Start Activity Fourth Title",
      imageUrl: "assets/images/q4.jpg",
      iconData: Icons.add_box,
    ),
  ];
@override
  void initState() {
  Timer.periodic(Duration(seconds: 2), (timer) {
    if(_currentIndex < 3 ) _currentIndex ++;
    // _controller.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/a': (ctx) => MyHomePage(),
      //   '/b': (ctx) => MainSplashScreen(),
      // },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Builder(
              builder: (ctx) => PageView(
                controller: _controller,
                children: myData.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(item.imageUrl),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.iconData,
                          size: 130,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          item.description,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onPageChanged: (val) {
                  setState(
                    () {
                      _currentIndex = val;
                      if (_currentIndex == 3) {
                        Future.delayed(
                          Duration(seconds: 2),
                          () => Navigator.pushReplacementNamed(ctx, '/b'),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Indicator(_currentIndex),
            Builder(
              builder: (ctx) => Align(
                alignment: Alignment(0, 0.93),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(7),
                  child: RaisedButton(
                    child: Text(
                      "GET STARTED",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    color: Colors.red,
                    onPressed: () {
                      // Navigator.of(ctx).pushReplacementNamed('/b');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int index;

  const Indicator(this.index);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainer(0,index == 0 ? Colors.green : Colors.red),
          buildContainer(1,index == 1 ? Colors.green : Colors.red),
          buildContainer(2,index == 2 ? Colors.green : Colors.red),
          buildContainer(3,index == 3 ? Colors.green : Colors.red),
        ],
      ),
    );
  }

  Widget buildContainer(int i,Color color) {
    return index == i?
        Icon(Icons.star,color: Colors.white,):Container(
      height: 15,
      width: 15,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

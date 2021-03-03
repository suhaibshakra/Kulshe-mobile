import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 60,),
          Text("More"),
        ],
      ),
    );
  }
}

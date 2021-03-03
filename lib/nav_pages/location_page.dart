import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_listed_location_outlined,size: 60,),
          Text("Location"),
        ],
      ),
    );
  }
}

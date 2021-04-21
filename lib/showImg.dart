import 'package:flutter/material.dart';

class ShowFullImage extends StatelessWidget {
  final img;
  ShowFullImage({this.img});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*1,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(img,),fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}

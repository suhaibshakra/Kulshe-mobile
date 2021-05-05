import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LazyLoadingPage extends StatefulWidget {
  @override
  _LazyLoadingPageState createState() => _LazyLoadingPageState();
}

class _LazyLoadingPageState extends State<LazyLoadingPage> {
  List dummyList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    dummyList = List.generate(10, (index) => "Item ${index+1}");
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _getMoreList();
      }
    });
    super.initState();
  }
  _getMoreList(){
    print('Get More List');
    for(int i=_currentMax;i < _currentMax + 10; i++){
      dummyList.add("Item: ${i + 1}");
    }
    _currentMax = _currentMax+10;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(controller: _scrollController,itemExtent: 70,itemCount: dummyList.length+1,itemBuilder: (context, index) {
        if(index == dummyList.length){
          return CupertinoActivityIndicator();
        }
        return ListTile(
          title: Text(dummyList[index]),
        );
      },),
    );
  }
}

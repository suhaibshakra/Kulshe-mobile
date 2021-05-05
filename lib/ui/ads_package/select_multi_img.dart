import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SelectMultiImage extends StatefulWidget {
  @override
  _SelectMultiImageState createState() => _SelectMultiImageState();
}

class _SelectMultiImageState extends State<SelectMultiImage> {
  List<Asset> images = <Asset>[];
  var newImages = [];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(05.0),
          child: Stack(
            children: [
              Container(width: 80,height: 80,
                child: AssetThumb(
                  asset: asset,
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    newImages.add(file);
    print('new: ${newImages.toString()}');
    return file;
  }

  convertData(){
    for (int i=0;i<images.length;i++){
      getImageFileFromAssets(images[i]);
    }
  }

  Future<void> loadAssets() async {
    print('image: $images');
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            Column(
              children: [
                ElevatedButton(
                  child: Text("Pick images"),
                  onPressed: loadAssets,
                ),
                ElevatedButton(
                  child: Text("convert images"),
                  onPressed: convertData,
                ),
              ],
            ),
            Container(
                width: double.infinity, height: 150, child: buildGridView()),
          ],
        ),
      ),
    );
  }
}

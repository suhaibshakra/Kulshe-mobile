import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: 130,
              width: double.infinity,
              child: Expanded(
                child: buildGridView(),
              ),
            ),
          ],
        ),
    );
  }

  Widget buildGridView() {
    return ListView.builder(
      itemCount: images.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      reverse: true,
      itemBuilder:(_ ,index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Stack(
           children: <Widget>[
             Card(
               elevation: 2,
               child: Image.file(
                 uploadModel.imageFile,
                 width: 130,
                 height: 130,fit: BoxFit.cover,
               ),
             ),
             Positioned(
               right: 5,
               top: 5,
               child: InkWell(
                 child: Icon(
                   Icons.delete_forever,
                   size: 25,
                   color: Colors.red,
                 ),
                 onTap: () {
                   setState(() {
                     images.replaceRange(index, index + 1, ['Add Image']);
                     images.removeAt(index);
                   });
                 },
               ),
             ),
           ],
            );
        } else {
          return Container(
            width: 130,
            height: 130,
            child: Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddImageClick(index);
                },
              ),
            ),
          );
        }
      }
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      if(file != null)
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
        if(images.length < 20)
        images.add("Add Image");

      });
    });
  }
}
class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
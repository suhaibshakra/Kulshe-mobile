import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';

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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: buildIcons(color: AppColors.redColor,size: 26,iconData: Icons.delete_forever,bgColor: AppColors.greyThree.withOpacity(0.7),hasShadow: false,action: (){
                    setState(() {
                      images.replaceRange(index, index + 1, ['Add Image']);
                      if(images.length>1)
                        images.removeAt(index);
                    });
                  }),

                  // child: InkWell(
                  //   child: Icon(
                  //     Icons.delete,
                  //     size: 26,
                  //     color: Colors.red,
                  //   ),
                  //   onTap: () {
                  //     setState(() {
                  //       images.replaceRange(index, index + 1, ['Add Image']);
                  //       if(images.length>1)
                  //         images.removeAt(index);
                  //     });
                  //   },
                  // ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      print(_imageFile);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {
      if(file!=null)
        setState(() {
          ImageUploadModel imageUpload = new ImageUploadModel();
          imageUpload.isUploaded = false;
          imageUpload.uploading = false;
          imageUpload.imageFile = file;
          imageUpload.imageUrl = '';
          images.replaceRange(index, index + 1, [imageUpload]);

          if(images.length<20)
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
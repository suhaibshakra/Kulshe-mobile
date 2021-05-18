import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

// import 'package:image_picker/image_picker.dart';
//
// class SingleImageUpload extends StatefulWidget {
//   @override
//   _SingleImageUploadState createState() {
//     return _SingleImageUploadState();
//   }
// }
//
// class _SingleImageUploadState extends State<SingleImageUpload> {
//   List<Object> images = List<Object>();
//   Future<File> _imageFile;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       images.add("Add Image");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         body: Column(
//           children: <Widget>[
//             Container(
//               height: 130,
//               width: double.infinity,
//               child: Expanded(
//                 child: buildGridView(),
//               ),
//             ),
//           ],
//         ),
//     );
//   }
//
//   Widget buildGridView() {
//     return ListView.builder(
//       itemCount: images.length,
//       scrollDirection: Axis.horizontal,
//       shrinkWrap: true,
//       reverse: true,
//       itemBuilder:(_ ,index) {
//         if (images[index] is ImageUploadModel) {
//           ImageUploadModel uploadModel = images[index];
//           return Stack(
//            children: <Widget>[
//              Card(
//                elevation: 2,
//                child: Image.file(
//                  uploadModel.imageFile,
//                  width: 130,
//                  height: 130,fit: BoxFit.cover,
//                ),
//              ),
//              Positioned(
//                right: 5,
//                top: 5,
//                child: InkWell(
//                  child: Icon(
//                    Icons.delete_forever,
//                    size: 25,
//                    color: Colors.red,
//                  ),
//                  onTap: () {
//                    setState(() {
//                      images.replaceRange(index, index + 1, ['Add Image']);
//                      images.removeAt(index);
//                    });
//                  },
//                ),
//              ),
//            ],
//             );
//         } else {
//           return Container(
//             width: 130,
//             height: 130,
//             child: Card(
//               child: IconButton(
//                 icon: Icon(Icons.add),
//                 onPressed: () {
//                   _onAddImageClick(index);
//                 },
//               ),
//             ),
//           );
//         }
//       }
//     );
//   }
//
//   Future _onAddImageClick(int index) async {
//     setState(() {
//       _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//       getFileImage(index);
//     });
//   }
//
//   void getFileImage(int index) async {
// //    var dir = await path_provider.getTemporaryDirectory();
//
//     _imageFile.then((file) async {
//       if(file != null)
//       setState(() {
//         ImageUploadModel imageUpload = new ImageUploadModel();
//         imageUpload.isUploaded = false;
//         imageUpload.uploading = false;
//         imageUpload.imageFile = file;
//         imageUpload.imageUrl = '';
//         images.replaceRange(index, index + 1, [imageUpload]);
//         if(images.length < 20)
//         images.add("Add Image");
//
//       });
//     });
//   }
// }
// class ImageUploadModel {
//   bool isUploaded;
//   bool uploading;
//   File imageFile;
//   String imageUrl;
//
//   ImageUploadModel({
//     this.isUploaded,
//     this.uploading,
//     this.imageFile,
//     this.imageUrl,
//   });
// }
class MultiTest extends StatefulWidget {
  @override
  _MultiTestState createState() => _MultiTestState();
}

class _MultiTestState extends State<MultiTest> {
  List<Asset> images = List<Asset>();

  List files = [];

  List<Asset> resultList;

  String _error = 'No Error Dectected';


  @override
  void initState() {
    super.initState();
  }
  _submit() async {
    for (int i = 0; i < images.length; i++) {
      var path2 = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var file = await getImageFileFromAsset(path2);
      var base64Image = base64Encode(file.readAsBytesSync());
      files.add(base64Image);
      print('Files : $files');
      // var data = {
      //   "files": files,
      // };
      // try {
      //   var response = await http.post(data, 'url')
      //   var body = jsonDecode(response.body);
      //   print(body);
      //   if (body['msg'] == "Success!") {
      //     print('posted successfully!');
      //   } else {
      //     print(context, body['msg']);
      //   }
      // } catch (e) {
      //   return e.message;
      // }
    }
  }
  getImageFileFromAsset(String path)async{
    final file = File(path);
    return file;
  }
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length,(index) {
        Asset asset = images[index];
        // asset.getByteData().then((value){
        //   print('Value: $value');
        // });
        // print('byteData: ${byteData.toString()}');
        _submit();
        print('Assets: ${asset.identifier}');
        FlutterAbsolutePath.getAbsolutePath(images[index].identifier).then((value){
          print('val: $value');
        });
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print('resultList: $resultList');
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      print('images: $images');
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
            ElevatedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}

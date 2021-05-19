// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:kulshe/app_helpers/app_colors.dart';
// import 'package:kulshe/app_helpers/app_controller.dart';
// import 'package:kulshe/app_helpers/app_widgets.dart';
// import 'package:kulshe/services_api/api.dart';
// import 'package:kulshe/services_api/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simple_location_picker/simple_location_picker_screen.dart';
// import 'package:simple_location_picker/simple_location_result.dart';
// import 'package:simple_location_picker/utils/slp_constants.dart';
//
// class AddAdDataScreen extends StatefulWidget {
//   final section;
//   final sectionId;
//   final subSectionId;
//
//   AddAdDataScreen({this.section, this.sectionId, this.subSectionId});
//
//   @override
//   _AddAdDataScreenState createState() => _AddAdDataScreenState();
// }
//
// class _AddAdDataScreenState extends State<AddAdDataScreen>{
//   String _lang;
//   bool _negotiable = false;
//   String _free;
//   bool _showContactInfo = true;
//   bool _isFree = false;
//   bool _isDelivery = false;
//   bool _loading = true;
//   bool hasSubBrands = false;
//   final _strController = AppController.strings;
//   TextEditingController _titleController = TextEditingController()..text;
//   TextEditingController _priceController = TextEditingController()..text;
//   TextEditingController _videoController = TextEditingController()..text;
//   TextEditingController _bodyController = TextEditingController()..text;
//   TextEditingController _birthDateController = TextEditingController()..text;
//   TextEditingController _test = TextEditingController()..text;
//   String _dropDownButtonValue = 'No Value Chosen';
//
//   // final Map<String,TextEditingController> mapController = {};
//   // List<TextEditingController> controllers = [];
//   final List<TextEditingController> _controllers = List();
//
//   List _adForm;
//   List _countryData;
//   List _citiesData;
//   List _currenciesData;
//   List _listAttributes;
//   List _listBrands;
//   List _listSubBrands;
//   SimpleLocationResult _selectedLocation;
//   String _cityId;
//   String _currencyId;
//   String _brandId;
//   String _subBrandId;
//   String testID;
//   double filterValue = 50.0;
//   DateTime _selectedDate;
//   Map myAdAttributes = {};
//   List<dynamic> myAdAttributesArray = [];
//   // var attributes = [];
//   // List<dynamic> checkboxDetails = [];
//
//   // _addController(var index){
//   //   index = TextEditingController()..text;
//   //   controllers.add(index);
//   // }
//   void _pickDateDialog(id) {
//     showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(1920),
//             lastDate: DateTime.now())
//         .then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       setState(() {
//         _selectedDate = pickedDate;
//         _birthDateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
//         test(id, _birthDateController.text);
//       });
//     });
//   }
//
//   _getCountries() async {
//     SharedPreferences _gp = await SharedPreferences.getInstance();
//     final List countries = jsonDecode(_gp.getString("allCountriesData"));
//     _countryData = countries[0]['responseData'];
//     setState(() {
//       _countryData = _countryData
//           .where((element) => element['classified'] == true)
//           .toList();
//       _citiesData = _countryData
//           .where((element) =>
//               element['id'].toString() == _gp.getString('countryId'))
//           .toList();
//       _citiesData = _citiesData[0]['cities'];
//     });
//     // print('_${_countryData.where((element) => element.classified == true)}');
//     // print(sections[0].responseData[4].name);
//   }
//
//   getLang() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = _prefs.getString('lang');
//     });
//   }
//
//   List listOfAttributeName;
//
//   bool hasBrand;
//   List _unitList;
//
//   @override
//   void initState() {
//     getLang();
//     _getCountries();
//     myAdAttributesArray = [];
//     myAdAttributes = {};
//     print(widget.section);
//     AdAddForm.getAdsForm(subSectionId: widget.subSectionId.toString())
//         .then((value) {
//       setState(() {
//         _adForm = value;
//         _currenciesData = value[0]['responseData']['currencies'];
//         _listAttributes = value[0]['responseData']['attributes'];
//         _unitList = _listAttributes
//             .where((element) => element['has_unit'] == 1)
//             .toList();
//         print(_unitList);
//         _listBrands = value[0]['responseData']['brands'];
//         // print(
//         //     '_listBrands[17] :${_listBrands.where((element) => element['id'] == 17)}');
//         // _listSubBrands = _listBrands.where((element) => element['sub_brands']!=[] || element['sub_brands']!=null).toList();
//         _showContactInfo = value[0]['responseData']['show_my_contact'];
//         _negotiable = value[0]['responseData']['negotiable'];
//         _isFree = value[0]['responseData']['if_free'];
//         _loading = false;
//
//         listOfAttributeName = _listAttributes
//             .where((element) => element['config']['type'] == 'select')
//             .toList();
//         // print('List: $listOfAttributeName');
//         var _dataCurrency = _currenciesData
//             .where((element) => element['default'] == true)
//             .toList();
//         _currencyId = _dataCurrency[0]['id'].toString();
//         // print('response  : $_listSubBrands');
//         // print('_AD  : $_dataCurrency');
//         // print('_AD  : $_dataCurrency');
//       });
//     });
//     super.initState();
//   }
//
//   Map<String, bool> _map;
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     return Scaffold(
//       appBar: buildAppBar(centerTitle: true, bgColor: AppColors.whiteColor),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Directionality(
//           textDirection: AppController.textDirection,
//           child: _loading
//               ? Center(child: buildLoading(color: AppColors.green))
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildPath(mq),
//                       _buildAttributes(mq, context),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Padding _buildAttributes(MediaQueryData mq, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         child: Card(
//           elevation: 8,
//           shadowColor: AppColors.grey,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.city,
//                       style:
//                           appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: 1,
//                       physics: ClampingScrollPhysics(),
//                       itemBuilder: (BuildContext context, index) {
//                         // print(_adForm[0]['responseData']['attributes'][0]['name']);
//                         return Container(
//                           decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(4)),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               Expanded(
//                                 flex: 1,
//                                 child: DropdownButtonHideUnderline(
//                                   child: ButtonTheme(
//                                     alignedDropdown: true,
//                                     child: DropdownButton<String>(
//                                       isExpanded: false,
//                                       value: _cityId,
//                                       iconSize: 30,
//                                       icon: (null),
//                                       style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 16,
//                                       ),
//                                       hint: Text(
//                                         _cityId != null
//                                             ? _cityId.toString()
//                                             : _strController.selectCity,
//                                         style: appStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16),
//                                       ),
//                                       onChanged: (String value) {
//                                         setState(() {
//                                           _cityId = value;
//                                           // print('Value:$value');
//                                         });
//                                       },
//                                       items: _citiesData.map((listCity) {
//                                             return new DropdownMenuItem(
//                                               child: new Text(
//                                                 listCity['label'][_lang],
//                                                 style: appStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16),
//                                               ),
//                                               value: listCity['id'].toString(),
//                                             );
//                                           })?.toList() ??
//                                           [],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.adTitle,
//                       style:
//                           appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Container(
//                       child: buildTextField(
//                           label: _strController.adTitle,
//                           controller: _titleController,
//                           textInputType: TextInputType.text),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 if (_adForm[0]['responseData']['has_price'])
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _strController.price,
//                             style: appStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           Container(
//                             child: buildTextField(
//                                 label: _strController.price,
//                                 controller: _priceController,
//                                 textInputType: TextInputType.number),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _strController.currencies,
//                             style: appStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: ClampingScrollPhysics(),
//                             itemCount: 1,
//                             itemBuilder: (BuildContext context, index) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade300,
//                                     borderRadius: BorderRadius.circular(4)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex: 1,
//                                       child: DropdownButtonHideUnderline(
//                                         child: ButtonTheme(
//                                           alignedDropdown: true,
//                                           child: DropdownButton<String>(
//                                             isExpanded: false,
//                                             value: _currencyId,
//                                             iconSize: 30,
//                                             icon: (null),
//                                             style: TextStyle(
//                                               color: Colors.black54,
//                                               fontSize: 16,
//                                             ),
//                                             hint: Text(
//                                               _currencyId.toString(),
//                                               style: appStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 18),
//                                             ),
//                                             onChanged: (String value) {
//                                               setState(() {
//                                                 _currencyId = value;
//                                               });
//                                             },
//                                             items: _currenciesData
//                                                     .map((listCurrency) {
//                                                   return new DropdownMenuItem(
//                                                     child: new Text(
//                                                       listCurrency[
//                                                               'currency_label']
//                                                           [_lang],
//                                                       style: appStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16),
//                                                     ),
//                                                     value: listCurrency['id']
//                                                         .toString(),
//                                                   );
//                                                 })?.toList() ??
//                                                 [],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       if (_adForm[0]['responseData']['has_brand'])
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "النوع",
//                               style: appStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: ClampingScrollPhysics(),
//                               itemCount: 1,
//                               itemBuilder: (BuildContext context, index) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(4)),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 1,
//                                         child: DropdownButtonHideUnderline(
//                                           child: ButtonTheme(
//                                             alignedDropdown: true,
//                                             child: DropdownButton<String>(
//                                               isExpanded: false,
//                                               value: _brandId,
//                                               iconSize: 30,
//                                               icon: (null),
//                                               style: appStyle(
//                                                 color: Colors.black54,
//                                                 fontSize: 16,
//                                               ),
//                                               hint: Text(
//                                                 // _brandId!=null?_brandId.toString():"choose type",
//                                                 _listBrands[0]['label'][_lang],
//                                                 style: appStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 18),
//                                               ),
//                                               onChanged: (String value) {
//                                                 setState(() {
//                                                   _subBrandId = null;
//                                                   _brandId = value;
//                                                   _listSubBrands = _listBrands
//                                                       .where((element) =>
//                                                           element['id']
//                                                               .toString() ==
//                                                           value.toString())
//                                                       .toList();
//                                                   _listSubBrands =
//                                                       _listSubBrands[0]
//                                                           ['sub_brands'];
//                                                   if (_listSubBrands != [] &&
//                                                       _listSubBrands != null &&
//                                                       _listSubBrands
//                                                           .isNotEmpty) {
//                                                     setState(() {
//                                                       hasSubBrands = true;
//                                                     });
//                                                   } else {
//                                                     setState(() {
//                                                       hasSubBrands = false;
//                                                     });
//                                                   }
//                                                   print(
//                                                       " typeee ${hasSubBrands}");
//                                                 });
//                                               },
//                                               items: _listBrands
//                                                       .map((listBrand) {
//                                                     // print("LIST BRAND ${listBrand['id']}");
//                                                     return new DropdownMenuItem(
//                                                       child: new Text(
//                                                         listBrand['label']
//                                                             [_lang],
//                                                         style: appStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 16),
//                                                       ),
//                                                       value: listBrand['id']
//                                                           .toString(),
//                                                     );
//                                                   })?.toList() ??
//                                                   [],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                             if (hasSubBrands == true)
//                               SizedBox(
//                                 height: 20,
//                               ),
//                             if (hasSubBrands == true)
//                               ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: ClampingScrollPhysics(),
//                                 itemCount: 1,
//                                 itemBuilder: (BuildContext context, index) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey.shade300,
//                                         borderRadius: BorderRadius.circular(4)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Expanded(
//                                           flex: 1,
//                                           child: DropdownButtonHideUnderline(
//                                             child: ButtonTheme(
//                                               alignedDropdown: true,
//                                               child: DropdownButton<String>(
//                                                 isExpanded: false,
//                                                 value: _subBrandId,
//                                                 iconSize: 30,
//                                                 icon: (null),
//                                                 style: appStyle(
//                                                   color: Colors.black54,
//                                                   fontSize: 16,
//                                                 ),
//                                                 hint: Text(
//                                                   // _subBrandId!=null?_subBrandId.toString():"choose sub type",
//                                                   _listSubBrands[0]['label']
//                                                       [_lang],
//                                                   style: appStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 18),
//                                                 ),
//                                                 onChanged: (String value) {
//                                                   setState(() {
//                                                     _subBrandId = value;
//                                                     // myAdAttributes[_listSubBrands[index]['name']] = value;
//                                                     // test(_listSubBrands[index]['id'], value);
//
//                                                     // print(" typeee ${value}");
//                                                   });
//                                                 },
//                                                 items: _listSubBrands
//                                                         .map((listSubBrand) {
//                                                       // print("LIST BRAND ${listSubBrand['id']}");
//                                                       return new DropdownMenuItem(
//                                                         child: new Text(
//                                                           listSubBrand['label']
//                                                               [_lang],
//                                                           style: appStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 16),
//                                                         ),
//                                                         value:
//                                                             listSubBrand['id']
//                                                                 .toString(),
//                                                       );
//                                                     })?.toList() ??
//                                                     [],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 if (_adForm[0]['responseData']['is_free'] ||
//                     _adForm[0]['responseData']['negotiable'])
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             if (_adForm[0]['responseData']['negotiable'])
//                               Container(
//                                 color: AppColors.whiteColor,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     buildTxt(txt: _strController.negotiable),
//                                     Transform.scale(
//                                       scale: 1.2,
//                                       child: Checkbox(
//                                         value: _negotiable,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _negotiable = value;
//                                           });
//                                         },
//                                         activeColor: Colors.green,
//                                         checkColor: Colors.white,
//                                         tristate: false,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             // if (_adForm[0]['responseData']['is_free'])
//                             //   Container(
//                             //     color: AppColors.whiteColor,
//                             //     child: Row(
//                             //       mainAxisAlignment: MainAxisAlignment.center,
//                             //       children: [
//                             //         buildTxt(txt: "مجانا"),
//                             //         Transform.scale(
//                             //           scale: 1.2,
//                             //           child: Checkbox(
//                             //             value: _isFree,
//                             //             onChanged: (value) {
//                             //               setState(() {
//                             //                 _isFree = value;
//                             //               });
//                             //             },
//                             //             activeColor: Colors.green,
//                             //             checkColor: Colors.white,
//                             //            ),
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ),
//                           ]),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 //attributes
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       itemCount: _listAttributes.length,
//                       itemBuilder: (BuildContext context, index) {
//                         // print("LISTAT: $_listAttributes");
//                         List _options = _listAttributes[index]['options'];
//                         var _type = _listAttributes[index]['config']['type'];
//                         // if (_type == 'string' || _type == 'number' || _type == 'year')
//                         //   _addController(index);
//                         // List<String> _optionsString = ['a','b','c'];
//                         // print(' OPTIONS :${_listAttributes[index]['name']}');
//                         // _optionsString.add(_listAttributes[index]['name']);
//                         // print(_optionsString);
//                         // _optionsString.forEach((String str) {
//                         //   var textEditingController = TextEditingController(text: str);
//                         //   controllers.add(textEditingController);
//                         // });
//                         // controllers[0] = _titleController;
//
//                         // print('CONTROLLERS : ${controllers[0].text.toString()}');
//                         // if (_type == 'string' || _type == 'number' || _type == 'year')
//                         //   controllers.add(TextEditingController(text: "$index"));
//                         //
//                         // print('controllerd: $controllers');
//                         _controllers.add(new TextEditingController());
//                         // _controllers[index].text = _listAttributes[index]['label'][_lang];
//                         // print('_c1:${_controllers[0].text}');
//                         return _buildNumTxt(index, _type, _options, mq);
//                       },
//                     ),
//                   ],
//                 ),
//                 if (_adForm[0]['responseData']['is_delivery'])
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         color: AppColors.whiteColor,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               buildTxt(txt: _strController.withDelivery),
//                               Transform.scale(
//                                 scale: 1.2,
//                                 child: Checkbox(
//                                   value: _isDelivery,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _isDelivery = value;
//                                     });
//                                   },
//                                   activeColor: Colors.green,
//                                   checkColor: Colors.white,
//                                   tristate: false,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.video,
//                       style:
//                           appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Container(
//                       child: buildTextField(
//                           suffix: Icon(
//                             FontAwesomeIcons.youtube,
//                             color: Colors.red,
//                             size: 16,
//                           ),
//                           fromPhone: true,
//                           label: _strController.video,
//                           controller: _videoController,
//                           textInputType: TextInputType.text),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.adDescription,
//                       style:
//                           appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Container(
//                       child: buildTextField(
//                           label: _strController.adDescription,
//                           controller: _bodyController,
//                           textInputType: TextInputType.text),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: MergeSemantics(
//                             child: ListTile(
//                               title: Text(
//                                 _strController.showContactInfo,
//                                 style: appStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16),
//                               ),
//                               trailing: CupertinoSwitch(
//                                 value: _showContactInfo,
//                                 onChanged: (bool value) {
//                                   setState(() {
//                                     _showContactInfo = value;
//                                   });
//                                 },
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   _showContactInfo = !_showContactInfo;
//                                 });
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 if (_adForm[0]['responseData']['has_map'])
//                   RaisedButton(
//                     child: Text(
//                       "Pick a Location",
//                       style:
//                           appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       double latitude = _selectedLocation != null
//                           ? _selectedLocation.latitude
//                           : SLPConstants.DEFAULT_LATITUDE;
//                       double longitude = _selectedLocation != null
//                           ? _selectedLocation.longitude
//                           : SLPConstants.DEFAULT_LONGITUDE;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SimpleLocationPicker(
//                                     zoomLevel: 18,
//                                     markerColor: AppColors.grey,
//                                     displayOnly: false,
//                                     appBarTextColor: AppColors.blackColor,
//                                     appBarColor: AppColors.whiteColor,
//                                     initialLatitude: latitude,
//                                     initialLongitude: longitude,
//                                     appBarTitle: "Select Location",
//                                   ))).then((value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedLocation = value;
//                           });
//                         }
//                       });
//                     },
//                   ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 _buildButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Padding _buildNumTxt(int index, _type, _options, MediaQueryData mq) {
//     List<dynamic> selectedValues = [];
//     String selectedValues2 = "";
//     // print(_listAttributes[index]["name"]);
//     if (_type != 'checkbox' ||
//         _type != 'radio') if (myAdAttributes[_listAttributes[index]["name"]]
//             ?.isEmpty ??
//         true) myAdAttributes[_listAttributes[index]["name"]] = selectedValues2;
//     if (_type == 'checkbox' ||
//         _type == 'radio') if (myAdAttributes[_listAttributes[index]["name"]]
//             ?.isEmpty ??
//         true) myAdAttributes[_listAttributes[index]["name"]] = selectedValues;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//             color: AppColors.greyThree, borderRadius: BorderRadius.circular(4)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _listAttributes[index]['label'][_lang].toString(),
//               style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               _type.toString(),
//               style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               _options.length.toString(),
//               style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             if (_options.length == 0)
//               if (_type == 'string' || _type == 'number' || _type == 'year')
//                 Column(
//                   children: [
//                     Container(
//                       height: 60,
//                       child: buildTextField(
//                           // controller:
//                           // _controllers[index] ,
//                           // TextEditingController.fromValue(
//                           //     TextEditingValue(
//                           //       text: "",
//                           //     ),
//                           // ),
//                           onChanged: (val) {
//                             // print(_options.toString());
//                             // print('${_listAttributes[index]['name'].toString()} : ${val}');
//                             // myCategoryDynamic[_listAttributes[index]['name']].add(val.toString());
//                             myAdAttributes[_listAttributes[index]['id']] = val;
//                             test(_listAttributes[index]['id'], val);
//                             print("s-n-y:  ${_listAttributes[index]['id']}");
//
//                             // print("sss");
//                             print(myAdAttributesArray);
//                             // print('MYCAT:$myAdAttributes');
//                           },
//                           label:
//                               _listAttributes[index]['label'][_lang].toString(),
//                           textInputType: TextInputType.text),
//                     ),
//                     Text("${_listAttributes[index]['units']}")
//                     // if (_listAttributes[index]['has_unit'] == 1)
//                     //   Column(
//                     //     children: [
//                     //       ListView.builder(
//                     //           shrinkWrap: true,
//                     //           physics: ClampingScrollPhysics(),
//                     //           itemCount: _unitList.length,
//                     //           itemBuilder: (BuildContext context, index) {
//                     //             print();
//                     //             return Text();
//                     //           }),
//                     //     ],
//                     //   )
//                   ],
//                 ),
//             if (_type == 'dob')
//               myButton(
//                   fontSize: 16,
//                   width: mq.size.width * 0.5,
//                   height: 45,
//                   onPressed: () =>
//                       _pickDateDialog(_listAttributes[index]['id']),
//                   radius: 10,
//                   btnTxt: _strController.chooseDate,
//                   txtColor: Colors.black54,
//                   btnColor: Colors.white),
//             if (_options.length != 0)
//               _buildSelectRadioCheckBox(_type, _options, _listAttributes[index])
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container _buildButton(BuildContext context) {
//     // print("AT:$myAdAttributes");
//     return Container(
//       child: myButton(
//         context: context,
//         height: 50,
//         width: double.infinity,
//         btnTxt: _strController.postAd,
//         fontSize: 20,
//         txtColor: AppColors.whiteColor,
//         radius: 10,
//         btnColor: AppColors.redColor,
//         onPressed: () {
//           addAdFunction(
//               context: context,
//               sectionId: widget.sectionId.toString(),
//               subSectionId: '${widget.subSectionId.toString()}',
//               title: _titleController.text.toString(),
//               bodyAd: _bodyController.text.toLowerCase(),
//               cityId: _cityId,
//               price: _priceController.text.toString().isNotEmpty
//                   ? double.parse(_priceController.text.toString())
//                   : 0,
//               localityId: '1',
//               lat: _selectedLocation != null
//                   ? '${_selectedLocation.latitude}'
//                   : "",
//               lag: _selectedLocation != null
//                   ? '${_selectedLocation.longitude}'
//                   : "",
//               brandId: _brandId != null ? _brandId : "",
//               subBrandId: _subBrandId != null ? _subBrandId : "",
//               isDelivery: true,
//               isFree: _isFree,
//               showContact: _showContactInfo,
//               negotiable: _negotiable,
//               zoom: 14,
//               adAttributes: myAdAttributesArray,
//               images: [],
//               currencyId: _currencyId);
//           // _validateAndSubmit();
//         },
//       ),
//     );
//   }
//
//   int groupValue = -1;
//
//   Container _buildSelectRadioCheckBox(_type, _options, var list) {
//     // List<dynamic> selectedValues = [];
//     // // // print(_listAttributes[index]["name"]);
//     // if(_type == 'checkbox' || _type == 'radio')
//     //   if(myCategoryDynamic[list["name"]]?.isEmpty ?? true)
//     //     myCategoryDynamic[list["name"]] = selectedValues;
//
//     return Container(
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: ClampingScrollPhysics(),
//         itemCount: _type == 'select' ? 1 : _options.length,
//         itemBuilder: (context, index) {
//           // print(' OP $_options');
//
//           return Column(
//             children: [
//               if (_type == 'radio')
//                 Row(
//                   children: <Widget>[
//                     Radio<dynamic>(
//                       focusColor: Colors.white,
//                       groupValue: list['name'],
//                       onChanged: (dynamic newValue) {
//                         test(list["id"], newValue);
//                         setState(() {
//                           list['name'] = newValue;
//                           test(list['id'], newValue);
//                           print("radio:  ${list['id']}");
//                           // print(_options[index]['label'][_lang]);
//                           // print(list['name']);
//                         });
//                       },
//                       value: _options[index]['id'],
//                     ),
//                     Text(
//                       _options[index]['label'][_lang],
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//
//               //DATA
//               if (_type == 'checkbox')
//                 Container(
//                   color: AppColors.whiteColor,
//                   child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: new CheckboxListTile(
//                           value: myAdAttributes[list['name']]
//                               .contains(_options[index]['id']),
//                           title: new Text("${_options[index]['label'][_lang]}"),
//                           controlAffinity: ListTileControlAffinity.leading,
//                           tristate: true,
//                           onChanged: (bool val) {
//                             setState(() {
//                               myAdAttributes[list['name']]
//                                       .contains(_options[index]['id'])
//                                   ? myAdAttributes[list['name']]
//                                       .remove(_options[index]['id'])
//                                   : myAdAttributes[list['name']]
//                                       .add(_options[index]['id']);
//                               test(list['id'], myAdAttributes[list['name']]);
//                               print(myAdAttributesArray);
//                             });
//                           })),
//                 ),
//               //TODO SELECT STATUS
//
//               if (_type == 'select')
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(4)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Expanded(
//                         flex: 1,
//                         child: DropdownButtonHideUnderline(
//                           child: ButtonTheme(
//                             alignedDropdown: true,
//                             child: DropdownButton<String>(
//                               isExpanded: false,
//                               value: _options[index]['id'].toString(),
//                               // value: '1',
//                               iconSize: 30,
//                               // icon: (null),
//                               style: appStyle(
//                                 color: Colors.black54,
//                                 fontSize: 16,
//                               ),
//                               hint: Text(
//                                 _options[index]['label'][_lang].toString(),
//                                 style: appStyle(
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   // myAdAttributes[_listAttributes[index]['id']] = value;
//                                   print(
//                                       "select:  ${listOfAttributeName[index]['id']}");
//                                   test(listOfAttributeName[index]['id'], value);
//                                   // testID = value;
//                                   print("$myAdAttributesArray");
//                                 });
//                               },
//                               items: _options
//                                       .map<DropdownMenuItem<String>>((list) {
//                                     // print('LIST  :$list');
//                                     return new DropdownMenuItem(
//                                       child:
//                                           new Text("${list['label'][_lang]}"),
//                                       value: list['id'].toString(),
//                                     );
//                                   })?.toList() ??
//                                   [],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Container _buildPath(MediaQueryData mq) {
//     return Container(
//       height: mq.size.height * 0.1,
//       child: Card(
//         elevation: 5,
//         shadowColor: AppColors.grey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Text(
//                 "${widget.section}",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               SizedBox(
//                 width: 30,
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 18,
//                   color: AppColors.grey,
//                 ),
//               ),
//               Text(
//                 "${_adForm[0]['responseData']['label']['ar']}",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   test(id, value) {
//     int trendIndex = myAdAttributesArray.indexWhere((f) => f['id'] == id);
//     // print(trendIndex);
//     print(id);
//     if (trendIndex == -1) {
//       Map<dynamic, dynamic> test = {"id": id, "value": value};
//       myAdAttributesArray.add(test);
//     } else {
//       myAdAttributesArray[trendIndex]["value"] = value;
//     }
//     print(myAdAttributesArray);
//   }
// }
















// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:kulshe/app_helpers/app_colors.dart';
// import 'package:kulshe/app_helpers/app_controller.dart';
// import 'package:kulshe/app_helpers/app_widgets.dart';
// import 'package:kulshe/services_api/api.dart';
// import 'package:kulshe/services_api/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simple_location_picker/simple_location_picker_screen.dart';
// import 'package:simple_location_picker/simple_location_result.dart';
// import 'package:simple_location_picker/utils/slp_constants.dart';
//
// class AddAdForm extends StatefulWidget {
//   final section;
//   final sectionId;
//   final subSectionId;
//
//   AddAdForm({this.section, this.sectionId, this.subSectionId});
//
//   @override
//   _AddAdFormState createState() => _AddAdFormState();
// }
//
// class _AddAdFormState extends State<AddAdForm> {
//   String _lang;
//   String _cityId;
//   String _currencyId;
//   String _brandId;
//   String _subBrandId;
//   String chosenDate = AppController.strings.chooseDate;
//   bool _negotiable = false;
//   bool _isFree = false;
//   bool _showContactInfo = true;
//   bool _isDelivery = false;
//   bool _loading = true;
//   bool hasSubBrands = false;
//   final _strController = AppController.strings;
//   TextEditingController _titleController = TextEditingController()..text;
//   TextEditingController _priceController = TextEditingController()..text;
//   TextEditingController _videoController = TextEditingController()..text;
//   TextEditingController _bodyController = TextEditingController()..text;
//   TextEditingController _birthDateController = TextEditingController()..text;
//   SimpleLocationResult _selectedLocation;
//   List _adForm;
//   List _countryData;
//   List _citiesData;
//   List _currenciesData;
//   List _listAttributes;
//   List _listBrands;
//   List _listSubBrands;
//   List _listUnits;
//   List _options;
//   String _type;
//   List<dynamic> myAdAttributesArray = []; //edit
//   Map myAdAttributes = {}; //edit
//   DateTime _selectedDate;
//
//   getLang() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = _prefs.getString('lang');
//     });
//   }
//
//   _getCountries() async {
//     SharedPreferences _gp = await SharedPreferences.getInstance();
//     final List countries = jsonDecode(_gp.getString("allCountriesData"));
//     _countryData = countries[0]['responseData'];
//     setState(() {
//       _countryData = _countryData
//           .where((element) => element['classified'] == true)
//           .toList();
//       _citiesData = _countryData
//           .where((element) =>
//       element['id'].toString() == _gp.getString('countryId'))
//           .toList();
//       _citiesData = _citiesData[0]['cities'];
//     });
//     // print('_${_countryData.where((element) => element.classified == true)}');
//     // print(sections[0].responseData[4].name);
//   }
//
//   test(id, value) {
//     int trendIndex = myAdAttributesArray.indexWhere((f) => f['id'] == id);
//     // print(trendIndex);
//     print(id);
//     if (trendIndex == -1) {
//       Map<dynamic, dynamic> test = {"id": id, "value": value};
//       myAdAttributesArray.add(test);
//     } else {
//       myAdAttributesArray[trendIndex]["value"] = value;
//     }
//     print(myAdAttributesArray);
//   }
//
//   void _pickDateDialog(id) {
//     showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(1920),
//         lastDate: DateTime.now())
//         .then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       setState(() {
//         _selectedDate = pickedDate;
//         _birthDateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
//         chosenDate = _birthDateController.text;
//         test(id, _birthDateController.text);
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     getLang();
//     _getCountries();
//     myAdAttributesArray = [];
//     myAdAttributes = {};
//     AdAddForm.getAdsForm(subSectionId: widget.subSectionId.toString())
//         .then((value) {
//       setState(() {
//         _adForm = value;
//         _currenciesData = value[0]['responseData']['currencies'];
//         _listAttributes = value[0]['responseData']['attributes'];
//         _listBrands = value[0]['responseData']['brands'];
//         _showContactInfo = value[0]['responseData']['show_my_contact'];
//         _negotiable = value[0]['responseData']['negotiable'];
//         _isFree = value[0]['responseData']['if_free'];
//         _loading = false;
//         var _dataCurrency = _currenciesData
//             .where((element) => element['default'] == true)
//             .toList();
//         _currencyId = _dataCurrency[0]['id'].toString();
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     return Scaffold(
//       appBar: buildAppBar(centerTitle: true, bgColor: AppColors.whiteColor),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Directionality(
//           textDirection: AppController.textDirection,
//           child: _loading
//               ? Center(child: buildLoading(color: AppColors.green))
//               : SingleChildScrollView(
//             child: Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildPath(mq),
//                   _buildConstData(),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         itemCount: _listAttributes.length,
//                         itemBuilder: (ctx, mainIndex) {
//                           _listUnits =_listAttributes[mainIndex]['units'];
//                           _options = _listAttributes[mainIndex]['options'];
//                           _type =
//                           _listAttributes[mainIndex]['config']['type'];
//                           List<dynamic> selectedValues = [];
//                           String selectedValues2 = "";
//                           if (_type != 'checkbox' ||
//                               _type != 'radio') if (myAdAttributes[
//                           _listAttributes[mainIndex]["name"]]
//                               ?.isEmpty ??
//                               true)
//                             myAdAttributes[_listAttributes[mainIndex]
//                             ["name"]] = selectedValues2;
//                           if (_type == 'checkbox' ||
//                               _type == 'radio') if (myAdAttributes[
//                           _listAttributes[mainIndex]["name"]]
//                               ?.isEmpty ??
//                               true)
//                             myAdAttributes[_listAttributes[mainIndex]
//                             ["name"]] = selectedValues;
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 8),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _listAttributes[mainIndex]['label'][_lang]
//                                       .toString(),
//                                   style: appStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 if (_options.length == 0)
//                                   if (_type == 'string' ||
//                                       _type == 'number' ||
//                                       _type == 'year')
//                                     buildTextField(
//                                         onChanged: (val) {
//                                           myAdAttributes[
//                                           _listAttributes[mainIndex]
//                                           ['id']] = val;
//                                           test(
//                                               _listAttributes[mainIndex]
//                                               ['id'],
//                                               val);
//                                           print(
//                                               "s-n-y:  ${_listAttributes[mainIndex]['id']}");
//
//                                           // print("sss");
//                                           print(myAdAttributesArray);
//                                           // print('MYCAT:$myAdAttributes');
//                                         },
//                                         label: _listAttributes[mainIndex]
//                                         ['label'][_lang]
//                                             .toString(),
//                                         textInputType: TextInputType.text),
//                                 if(_listAttributes[mainIndex]['has_unit']==1)
//                                 // Text("mainIndex:${mainIndex} ${_listAttributes[mainIndex]['units']}"),
//                                   ListView.builder(itemCount: 1,physics: ClampingScrollPhysics(),shrinkWrap: true,itemBuilder: (_,unitIndex){
//                                     return Column(
//                                       children: [
//                                         if(_listAttributes[mainIndex]['id'] == _listUnits[unitIndex]['attribute_id'])
//                                           Text("${_listAttributes[mainIndex]['units'][unitIndex]['label']}"),
//                                         if(_listAttributes[mainIndex]['id'] == _listUnits[unitIndex]['attribute_id'])
//                                           Container(
//                                             decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(8)),
//                                             child: Column(
//                                               children: [
//                                                 DropdownButtonHideUnderline(
//                                                   child: ButtonTheme(
//                                                     alignedDropdown: true,
//                                                     child: DropdownButton<String>(
//                                                       isExpanded: true,
//                                                       // value: _listUnits[unitIndex]['unit_id'].toString(),
//                                                       // value: '1',
//                                                       iconSize: 30,
//                                                       // icon: (null),
//                                                       style: appStyle(
//                                                         color: Colors.black54,
//                                                         fontSize: 16,
//                                                       ),
//                                                       hint: Text(
//                                                         _listUnits[unitIndex]['label'][_lang].toString(),
//                                                         style: appStyle(
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                       onChanged: (value) {
//                                                         setState(() {
//                                                           // testID = value;
//                                                           print("$value");
//                                                         });
//                                                       },
//                                                       items: _listUnits
//                                                           .map<DropdownMenuItem<String>>((listUnits) {
//                                                         // print('LIST  :$list');
//                                                         return new DropdownMenuItem(
//                                                           child:
//                                                           new Text("${listUnits['label'][_lang]}"),
//                                                           value: _listUnits[unitIndex]['unit_id'].toString(),
//                                                         );
//                                                       })?.toList() ??
//                                                           [],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                       ],
//                                     );
//                                   }),
//
//                                 if (_type == 'dob')
//                                   myButton(
//                                       fontSize: 16,
//                                       width: mq.size.width * 0.5,
//                                       height: 45,
//                                       onPressed: () => _pickDateDialog(
//                                           _listAttributes[mainIndex]['id']),
//                                       radius: 10,
//                                       btnTxt: chosenDate,
//                                       txtColor: Colors.black54,
//                                       btnColor: Colors.white),
//                                 if (_options.length != 0)
//                                   GridView.builder(
//                                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: _type == 'select'?7:3,crossAxisCount: _type == 'select'?1:2),
//                                       shrinkWrap: true,
//                                       physics: ClampingScrollPhysics(),
//                                       itemCount: _type == 'select'
//                                           ? 1
//                                           : _options.length,
//                                       itemBuilder: (context, rcsIndex) {
//                                         return Container(
//                                           decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2),borderRadius: _type == 'select'?BorderRadius.circular(8):BorderRadius.circular(0)),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children: [
//                                               if (_type == 'radio')
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Radio<dynamic>(
//                                                       focusColor: Colors.white,
//                                                       groupValue: _listAttributes[mainIndex]['name'],
//                                                       onChanged: (dynamic newValue) {
//                                                         test(_listAttributes[mainIndex]["id"], newValue);
//                                                         setState(() {
//                                                           _listAttributes[mainIndex]['name'] = newValue;
//                                                           test(_listAttributes[mainIndex]['id'], newValue);
//                                                           print("radio:  ${_listAttributes[mainIndex]['id']}");
//                                                           // print(_options[index]['label'][_lang]);
//                                                           // print(list['name']);
//                                                         });
//                                                       },
//                                                       value: _options[rcsIndex]['id'],
//                                                     ),
//                                                     Text(
//                                                       _options[rcsIndex]['label'][_lang],
//                                                       style: TextStyle(fontWeight: FontWeight.bold),
//                                                     ),
//                                                   ],
//                                                 ),
//
//                                               if (_type == 'checkbox')
//                                                 CheckboxListTile(
//                                                     value: myAdAttributes[_listAttributes[mainIndex]['name']]
//                                                         .contains(_options[rcsIndex]['id']),
//                                                     title: new Text("${_options[rcsIndex]['label'][_lang]}"),
//                                                     controlAffinity: ListTileControlAffinity.leading,
//                                                     tristate: true,
//                                                     onChanged: (bool val) {
//                                                       setState(() {
//                                                         myAdAttributes[_listAttributes[mainIndex]['name']]
//                                                             .contains(_options[rcsIndex]['id'])
//                                                             ? myAdAttributes[_listAttributes[mainIndex]['name']]
//                                                             .remove(_options[rcsIndex]['id'])
//                                                             : myAdAttributes[_listAttributes[mainIndex]['name']]
//                                                             .add(_options[rcsIndex]['id']);
//                                                         test(_listAttributes[mainIndex]['id'], myAdAttributes[_listAttributes[mainIndex]['name']]);
//                                                         print(myAdAttributesArray);
//                                                       });
//                                                     }),
//
//                                               if (_type == 'select')
//                                                 Container(
//                                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                                                   child: Column(
//                                                     children: [
//                                                       DropdownButtonHideUnderline(
//                                                         child: ButtonTheme(
//                                                           alignedDropdown: true,
//                                                           child: DropdownButton<String>(
//                                                             isExpanded: true,
//                                                             value: _options[rcsIndex]['id'].toString(),
//                                                             // value: '1',
//                                                             iconSize: 30,
//                                                             // icon: (null),
//                                                             style: appStyle(
//                                                               color: Colors.black54,
//                                                               fontSize: 16,
//                                                             ),
//                                                             hint: Text(
//                                                               _options[rcsIndex]['label'][_lang].toString(),
//                                                               style: appStyle(
//                                                                 fontSize: 16,
//                                                               ),
//                                                             ),
//                                                             onChanged: (value) {
//                                                               setState(() {
//                                                                 print(
//                                                                     "select:  ${_listAttributes[mainIndex]['id']}");
//                                                                 test(_listAttributes[mainIndex]['id'], value);
//                                                                 // testID = value;
//                                                                 print("$myAdAttributesArray");
//                                                               });
//                                                             },
//                                                             items: _options
//                                                                 .map<DropdownMenuItem<String>>((listOptions) {
//                                                               // print('LIST  :$list');
//                                                               return new DropdownMenuItem(
//                                                                 child:
//                                                                 new Text("${listOptions['label'][_lang]}"),
//                                                                 value: listOptions['id'].toString(),
//                                                               );
//                                                             })?.toList() ??
//                                                                 [],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                               ],
//                             ),
//                           );
//                         }),
//                   ),
//                   _buildButton(context),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Container _buildPath(MediaQueryData mq) {
//     return Container(
//       height: mq.size.height * 0.1,
//       child: Card(
//         elevation: 5,
//         shadowColor: AppColors.grey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Text(
//                 "${widget.section}",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               SizedBox(
//                 width: 30,
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 18,
//                   color: AppColors.grey,
//                 ),
//               ),
//               Text(
//                 "${_adForm[0]['responseData']['label']['ar']}",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Container _buildButton(BuildContext context) {
//     // print("AT:$myAdAttributes");
//     return Container(
//       child: myButton(
//         context: context,
//         height: 50,
//         width: double.infinity,
//         btnTxt: _strController.postAd,
//         fontSize: 20,
//         txtColor: AppColors.whiteColor,
//         radius: 10,
//         btnColor: AppColors.redColor,
//         onPressed: () {
//           addAdFunction(
//               context: context,
//               sectionId: widget.sectionId.toString(),
//               subSectionId: '${widget.subSectionId.toString()}',
//               title: _titleController.text.toString(),
//               bodyAd: _bodyController.text.toLowerCase(),
//               cityId: _cityId,
//               price: _priceController.text.toString().isNotEmpty
//                   ? double.parse(_priceController.text.toString())
//                   : 0,
//               localityId: '1',
//               lat: _selectedLocation != null
//                   ? '${_selectedLocation.latitude}'
//                   : "",
//               lag: _selectedLocation != null
//                   ? '${_selectedLocation.longitude}'
//                   : "",
//               brandId: _brandId != null ? _brandId : "",
//               subBrandId: _subBrandId != null ? _subBrandId : "",
//               isDelivery: true,
//               isFree: _isFree,
//               showContact: _showContactInfo,
//               negotiable: _negotiable,
//               zoom: 14,
//               adAttributes: myAdAttributesArray,
//               images: [],
//               currencyId: _currencyId);
//           // _validateAndSubmit();
//         },
//       ),
//     );
//   }
//
//   _buildConstData() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(4)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: DropdownButtonHideUnderline(
//                     child: ButtonTheme(
//                       alignedDropdown: true,
//                       child: DropdownButton<String>(
//                         isExpanded: false,
//                         value: _cityId,
//                         iconSize: 30,
//                         icon: (null),
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 16,
//                         ),
//                         hint: Text(
//                           _cityId != null
//                               ? _cityId.toString()
//                               : _strController.selectCity,
//                           style: appStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         onChanged: (String value) {
//                           setState(() {
//                             _cityId = value;
//                             // print('Value:$value');
//                           });
//                         },
//                         items: _citiesData.map((listCity) {
//                           return new DropdownMenuItem(
//                             child: new Text(
//                               listCity['label'][_lang],
//                               style: appStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16),
//                             ),
//                             value: listCity['id'].toString(),
//                           );
//                         })?.toList() ??
//                             [],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _strController.adTitle,
//                 style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Container(
//                 child: buildTextField(
//                     label: _strController.adTitle,
//                     controller: _titleController,
//                     textInputType: TextInputType.text),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _strController.adDescription,
//                 style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Container(
//                 child: buildTextField(
//                   label: _strController.adDescription,
//                   controller: _bodyController,
//                   minLines: 4,
//                   maxLines: 8,
//                   textInputType: TextInputType.multiline,),
//               ),
//             ],
//           ),
//         ),
//         if (_adForm[0]['responseData']['has_price'])
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.price,
//                       style:
//                       appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     Container(
//                       child: buildTextField(
//                           label: _strController.price,
//                           controller: _priceController,
//                           textInputType: TextInputType.number),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _strController.currencies,
//                       style:
//                       appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(4)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Expanded(
//                             flex: 1,
//                             child: DropdownButtonHideUnderline(
//                               child: ButtonTheme(
//                                 alignedDropdown: true,
//                                 child: DropdownButton<String>(
//                                   isExpanded: false,
//                                   value: _currencyId,
//                                   iconSize: 30,
//                                   icon: (null),
//                                   style: TextStyle(
//                                     color: Colors.black54,
//                                     fontSize: 16,
//                                   ),
//                                   hint: Text(
//                                     _currencyId.toString(),
//                                     style: appStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   ),
//                                   onChanged: (String value) {
//                                     setState(() {
//                                       _currencyId = value;
//                                     });
//                                   },
//                                   items: _currenciesData.map((listCurrency) {
//                                     return new DropdownMenuItem(
//                                       child: new Text(
//                                         listCurrency['currency_label']
//                                         [_lang],
//                                         style: appStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16),
//                                       ),
//                                       value: listCurrency['id'].toString(),
//                                     );
//                                   })?.toList() ??
//                                       [],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         if (_adForm[0]['responseData']['has_brand'])
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "النوع",
//                   style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(4)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Expanded(
//                         flex: 1,
//                         child: DropdownButtonHideUnderline(
//                           child: ButtonTheme(
//                             alignedDropdown: true,
//                             child: DropdownButton<String>(
//                               isExpanded: false,
//                               value: _brandId,
//                               iconSize: 30,
//                               icon: (null),
//                               style: appStyle(
//                                 color: Colors.black54,
//                                 fontSize: 16,
//                               ),
//                               hint: Text(
//                                 // _brandId!=null?_brandId.toString():"choose type",
//                                 _listBrands[0]['label'][_lang],
//                                 style: appStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18),
//                               ),
//                               onChanged: (String value) {
//                                 setState(() {
//                                   _subBrandId = null;
//                                   _brandId = value;
//                                   _listSubBrands = _listBrands
//                                       .where((element) =>
//                                   element['id'].toString() ==
//                                       value.toString())
//                                       .toList();
//                                   _listSubBrands =
//                                   _listSubBrands[0]['sub_brands'];
//                                   if (_listSubBrands != [] &&
//                                       _listSubBrands != null &&
//                                       _listSubBrands.isNotEmpty) {
//                                     setState(() {
//                                       hasSubBrands = true;
//                                     });
//                                   } else {
//                                     setState(() {
//                                       hasSubBrands = false;
//                                     });
//                                   }
//                                   print(" typeee ${hasSubBrands}");
//                                 });
//                               },
//                               items: _listBrands.map((listBrand) {
//                                 // print("LIST BRAND ${listBrand['id']}");
//                                 return new DropdownMenuItem(
//                                   child: new Text(
//                                     listBrand['label'][_lang],
//                                     style: appStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                   value: listBrand['id'].toString(),
//                                 );
//                               })?.toList() ??
//                                   [],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (hasSubBrands == true)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20, bottom: 20),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(4)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Expanded(
//                             flex: 1,
//                             child: DropdownButtonHideUnderline(
//                               child: ButtonTheme(
//                                 alignedDropdown: true,
//                                 child: DropdownButton<String>(
//                                   isExpanded: false,
//                                   value: _subBrandId,
//                                   iconSize: 30,
//                                   icon: (null),
//                                   style: appStyle(
//                                     color: Colors.black54,
//                                     fontSize: 16,
//                                   ),
//                                   hint: Text(
//                                     // _subBrandId!=null?_subBrandId.toString():"choose sub type",
//                                     _listSubBrands[0]['label'][_lang],
//                                     style: appStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   ),
//                                   onChanged: (String value) {
//                                     setState(() {
//                                       _subBrandId = value;
//                                       // myAdAttributes[_listSubBrands[index]['name']] = value;
//                                       // test(_listSubBrands[index]['id'], value);
//
//                                       // print(" typeee ${value}");
//                                     });
//                                   },
//                                   items: _listSubBrands.map((listSubBrand) {
//                                     // print("LIST BRAND ${listSubBrand['id']}");
//                                     return new DropdownMenuItem(
//                                       child: new Text(
//                                         listSubBrand['label'][_lang],
//                                         style: appStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16),
//                                       ),
//                                       value: listSubBrand['id'].toString(),
//                                     );
//                                   })?.toList() ??
//                                       [],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: MergeSemantics(
//                       child: ListTile(
//                         title: Text(
//                           _strController.showContactInfo,
//                           style: appStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         trailing: CupertinoSwitch(
//                           value: _showContactInfo,
//                           onChanged: (bool value) {
//                             setState(() {
//                               _showContactInfo = value;
//                             });
//                           },
//                         ),
//                         onTap: () {
//                           setState(() {
//                             _showContactInfo = !_showContactInfo;
//                           });
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (_adForm[0]['responseData']['is_delivery'])
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   color: AppColors.whiteColor,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         buildTxt(
//                             txt: _strController.withDelivery,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700),
//                         Transform.scale(
//                           scale: 1.4,
//                           child: Checkbox(
//                             value: _isDelivery,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isDelivery = value;
//                               });
//                             },
//                             activeColor: Colors.green,
//                             checkColor: Colors.white,
//                             tristate: false,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _strController.video,
//                 style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Container(
//                 child: buildTextField(
//                     suffix: Icon(
//                       FontAwesomeIcons.youtube,
//                       color: Colors.red,
//                       size: 16,
//                     ),
//                     fromPhone: true,
//                     label: _strController.video,
//                     controller: _videoController,
//                     textInputType: TextInputType.text),
//               ),
//             ],
//           ),
//         ),
//         if (_adForm[0]['responseData']['has_map'])
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Container(
//               alignment: Alignment.center,
//               child: RaisedButton(
//                 child: Text(
//                   "Pick a Location",
//                   style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 onPressed: () {
//                   double latitude = _selectedLocation != null
//                       ? _selectedLocation.latitude
//                       : SLPConstants.DEFAULT_LATITUDE;
//                   double longitude = _selectedLocation != null
//                       ? _selectedLocation.longitude
//                       : SLPConstants.DEFAULT_LONGITUDE;
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SimpleLocationPicker(
//                             zoomLevel: 18,
//                             markerColor: AppColors.grey,
//                             displayOnly: false,
//                             appBarTextColor: AppColors.blackColor,
//                             appBarColor: AppColors.whiteColor,
//                             initialLatitude: latitude,
//                             initialLongitude: longitude,
//                             appBarTitle: "Select Location",
//                           ))).then((value) {
//                     if (value != null) {
//                       setState(() {
//                         _selectedLocation = value;
//                       });
//                     }
//                   });
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
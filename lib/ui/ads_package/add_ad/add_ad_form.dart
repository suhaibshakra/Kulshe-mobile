import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:simple_location_picker/simple_location_result.dart';
import 'package:simple_location_picker/utils/slp_constants.dart';
import 'package:toast/toast.dart';
import '../select_multi_img.dart';

class AddAdForm extends StatefulWidget {
  final String section;
  final sectionId;
  final subSectionId;
  final bool fromEdit;
  final int adID;

  AddAdForm(
      {this.section,
      this.sectionId,
      this.subSectionId,
      this.adID,
      this.fromEdit});

  @override
  _AddAdFormState createState() => _AddAdFormState();

  static getAdsForm({String adID}) {}
}

class _AddAdFormState extends State<AddAdForm> {
  String _lang;
  String _cityId;
  String _currencyId;
  String _brandId;
  String _subBrandId;
  double _lat;
  double _lng;
  String chosenDate = AppController.strings.chooseDate;
  bool _negotiable = false;
  bool _isFree = false;
  bool _showContactInfo = true;
  bool _isDelivery = false;
  bool _loading = true;
  bool hasSubBrands = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _strController = AppController.strings;
  TextEditingController _titleController = TextEditingController()..text;
  TextEditingController _priceController = TextEditingController()..text;
  TextEditingController _videoController = TextEditingController()..text;
  TextEditingController _bodyController = TextEditingController()..text;
  TextEditingController _birthDateController = TextEditingController()..text;
  SimpleLocationResult _selectedLocation;
  List _adForm;
  List _countryData;
  List _citiesData;
  List _currenciesData;
  List _listAttributes;
  List _listBrands;
  List _listSubBrands;
  List _listUnits;
  String _values;
  List _options;
  List _images;
  String _type;
  var validation;
  List<dynamic> myAdAttributesArray = []; //edit
  List<dynamic> myAdAttributesMulti = []; //edit
  Map myAdAttributes = {}; //edit
  DateTime _selectedDate;
  final ImagePicker _picker = ImagePicker();
  File _userImageFile;
  var bytes;
  File _pickedImage;
  var _userImage;
  var _imgURL;

  // void _pickImageLast(ImageSource src) async {
  //   final pickedImageFile =
  //   await _picker.getImage(source: src, imageQuality: 50, maxWidth: 150);
  //   // // print('PC:$_picker');
  //   if (pickedImageFile != null) {
  //     setState(() {
  //       _pickedImage = File(pickedImageFile.path);
  //     });
  //     _userImageFile = _pickedImage;
  //     bytes = File(_userImageFile.path).readAsBytesSync();
  //
  //     String fileName = _userImageFile.path.split('/').last;
  //     fileName = fileName.split('.').last;
  //
  //     // // print(fileName);
  //     // // print("data:image/$fileName;base64,${base64Encode(bytes)}");
  //     _userImage = "data:image/$fileName;base64,${base64Encode(bytes)}";
  //     _images.add({"image": _userImage != null ? _userImage : "sss"});
  //   } else {
  //     // print('No Image Selected');
  //   }
  // }

  getLang() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = _prefs.getString('lang');
    });
  }

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    _countryData = countries[0]['responseData'];
    setState(() {
      _countryData = _countryData
          .where((element) => element['classified'] == true)
          .toList();
      _citiesData = _countryData
          .where((element) =>
              element['id'].toString() == _gp.getString('countryId'))
          .toList();
      _citiesData = _citiesData[0]['cities'];
    });
    // // print('_${_countryData.where((element) => element.classified == true)}');
    // // print(sections[0].responseData[4].name);
  }

  _buildMap(id, value, {unitID}) {
    // // print(id);
    // // print(unitID);
    // // print(unitID != null);
    int trendIndex = myAdAttributesArray.indexWhere((f) => f['id'] == id);
    // // print(trendIndex);
    // // print(id);
    if (trendIndex == -1) {
      Map<dynamic, dynamic> mapData = unitID != null
          ? {"id": id, "value": value, "unit_id": unitID}
          : {"id": id, "value": value};
      myAdAttributesArray.add(mapData);
    } else {
      myAdAttributesArray[trendIndex]["value"] = value;
      if (unitID != null) myAdAttributesArray[trendIndex]["unit_id"] = unitID;
    }
    // // print(myAdAttributesArray);
  }

  void _pickDateDialog(id, {String value}) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;

        _birthDateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
        chosenDate = _birthDateController.text;
        _buildMap(id, _birthDateController.text);
      });
    });
  }

  @override
  void initState() {
    // // print('adID : ${widget.adID}');
    getLang();
    _getCountries();
    myAdAttributesArray = [];
    myAdAttributes = {};
    myAdAttributesMulti = [];

    AdAddForm.getAdsForm(subSectionId: widget.subSectionId.toString())
        .then((value) {
      setState(() {
        _adForm = value;
        _currenciesData = value[0]['responseData']['currencies'];
        _listAttributes = value[0]['responseData']['attributes'];
        _listBrands = value[0]['responseData']['brands'];
        final jsonList = value[0]['responseData']['brands']
            .map((item) => jsonEncode(item))
            .toList();

        // using toSet - toList strategy
        final uniqueJsonList = jsonList.toSet().toList();

        // convert each item back to the original form using JSON decoding
        _listBrands = uniqueJsonList.map((item) => jsonDecode(item)).toList();

        _showContactInfo = value[0]['responseData']['show_my_contact'];
        _negotiable = value[0]['responseData']['negotiable'];
        _isFree = value[0]['responseData']['if_free'];
        _loading = false;
        var _dataCurrency = _currenciesData
            .where((element) => element['default'] == true)
            .toList();
        _currencyId = _dataCurrency[0]['id'].toString();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: buildAppBar(centerTitle: true, bgColor: AppColors.whiteColor),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: AppController.textDirection,
          child: _loading
              ? Center(child: buildLoading(color: AppColors.redColor))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.fromEdit) _buildPath(),
                          // buildTxt(txt: "إختر من معرض الصور"),
                          // Container(height: 130, child: SingleImageUpload()),
                          _buildConstData(),
                          _buildDynamicData(mq),
                          // Center(
                          //   child: buildIconWithTxt(
                          //     iconData: Icons.image_outlined,
                          //     iconColor: AppColors.redColor,
                          //     label: Text(
                          //       _strController.labelGallery,
                          //       style: appStyle(
                          //           fontSize: 16,
                          //           color: AppColors.redColor,
                          //           fontWeight: FontWeight.w400),
                          //     ),
                          //     action: () => _pickImageLast(ImageSource.gallery),
                          //   ),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Padding _buildDynamicData(MediaQueryData mq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: _listAttributes.length,
          itemBuilder: (ctx, mainIndex) {
            // // print('MY VALUES: $_values');
            _listUnits = _listAttributes[mainIndex]['units'];
            _options = _listAttributes[mainIndex]['options'];
            _type = _listAttributes[mainIndex]['config']['type'];
            _type = _listAttributes[mainIndex]['config']['type'];
            // List<dynamic> selectedValues = [];
            // String selectedValues2 = "";
            // if (_type != 'checkbox' || _type != 'radio')
            //   if (myAdAttributes[_listAttributes[mainIndex]["name"]]?.isEmpty ??true)
            //   myAdAttributes[_listAttributes[mainIndex]["name"]] =selectedValues2;
            // if (_type == 'checkbox' || _type == 'radio')
            //   if (myAdAttributes[_listAttributes[mainIndex]["name"]]?.isEmpty ??true)
            //   myAdAttributes[_listAttributes[mainIndex]["name"]] =selectedValues;
            return buildMainAttributes(mainIndex, mq);
          }),
    );
  }

  Padding buildMainAttributes(int mainIndex, MediaQueryData mq) {
    // print("VAL:${_listAttributes[mainIndex]['label'][_lang]}");
    // print("type:${_type}");
    // print("_options:${_options}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _listAttributes[mainIndex]['label'][_lang].toString(),
            style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (_type == 'string' || _type == 'number' || _type == 'year')
            _buildSNY(mainIndex),
          if (_listAttributes[mainIndex]['has_unit'] == 1)
            // Text("mainIndex:${mainIndex} ${_listAttributes[mainIndex]['units']}"),
            ListView.builder(
                itemCount: 1,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, unitIndex) {
                  return Column(
                    children: [
                      if (_listAttributes[mainIndex]['id'] ==
                          _listUnits[unitIndex]['attribute_id'])
                        if (_listAttributes[mainIndex]['id'] ==
                            _listUnits[unitIndex]['attribute_id'])
                          _buildUnits(_listUnits, unitIndex, mainIndex),
                      // TODO: UNITS
                    ],
                  );
                }),
          if (_type == 'dob')
            myButton(
                fontSize: 16,
                width: mq.size.width * 0.5,
                height: 45,
                onPressed: () {
                  // print("${_listAttributes[mainIndex]['value']}");
                  _pickDateDialog(_listAttributes[mainIndex]['id'], value: "");
                },
                radius: 10,
                btnTxt: chosenDate,
                txtColor: Colors.black54,
                btnColor: Colors.white),
          if (_type == 'multiple_select' ||
              _type == 'select' ||
              _type == 'checkbox' ||
              _type == 'buttons_groups' ||
              _type == 'multiple_buttons_groups' ||
              _type == 'radio')
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: _type == 'radio' ? 50 : null,
                    childAspectRatio: _type == 'select'
                        ? 7
                        : (_type == 'multiple_select')
                            ? (_options.length > 4
                                ? 1.5
                                : _options.length * 2.0)
                            : 3,
                    crossAxisCount:
                        _type == 'select' || _type == 'multiple_select'
                            ? 1
                            : 2),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _type == 'select' || _type == 'multiple_select'
                    ? 1
                    : _options.length,
                itemBuilder: (context, rcsIndex) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: _type == 'select'
                            ? BorderRadius.circular(8)
                            : BorderRadius.circular(0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (_type == 'radio') _buildRadio(mainIndex, rcsIndex),
                        if (_type == 'checkbox' ||
                            _type == 'buttons_groups' ||
                            _type == 'multiple_buttons_groups')
                          _buildCheckbox(mainIndex, rcsIndex),
                        if (_type == 'select')
                          _buildSelect(rcsIndex, mainIndex),
                        if (_type == 'multiple_select')
                          buildMultiSelected(mainIndex),
                      ],
                    ),
                  );
                }),
        ],
      ),
    );
  }
  Container _buildUnits(List _listUnits, int unitIndex, int mainIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    if (trendIndex == -1) {
      _buildMap(_listAttributes[mainIndex]['id'],
          _listAttributes[mainIndex]['units'][0]['id'],
          unitID: _listUnits[0]['unit_id']);
      trendIndex = myAdAttributesArray
          .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    }
    return Container(
      width: 373.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isExpanded: true,
                value: myAdAttributesArray[trendIndex]['unit_id'].toString(),
                iconSize: 30,
                style: appStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                hint: Text(
                  _listUnits[unitIndex]['label'][_lang].toString(),
                  style: appStyle(
                    fontSize: 16,
                  ),
                ),
                onChanged: (value) {
                  // // print(_listAttributes[mainIndex]['units'][unitIndex].toString());
                  setState(() {
                    // testID = value;
                    // // print(_listAttributes[mainIndex]['id']);
                    // // print(_listAttributes[mainIndex]);
                    int trendIndex = myAdAttributesArray.indexWhere(
                        (f) => f['id'] == _listAttributes[mainIndex]['id']);
                    // // print('op:${_listAttributes[mainIndex]}');
                    // if(trendIndex!= -1)
                    if (trendIndex == -1) {
                      _buildMap(_listAttributes[mainIndex]['id'], '',
                          unitID: value);
                    } else {
                      _buildMap(_listAttributes[mainIndex]['id'],
                          myAdAttributesArray[trendIndex]['value'],
                          unitID: value);
                    }
                  });
                },
                items: _listUnits.map<DropdownMenuItem<String>>((listUnits) {
                      // // print('LIST  :$list');
                      return new DropdownMenuItem(
                        child: new Text("${listUnits['label'][_lang]}"),
                        value: listUnits['unit_id'].toString(),
                      );
                    })?.toList() ??
                    [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildSNY(int mainIndex) {
    var initialValue = '';

    return Container(
      child: buildTextField(
          initialValue: initialValue,
          onChanged: (val) {
            myAdAttributes[_listAttributes[mainIndex]['id']] = val;
            if (_listAttributes[mainIndex]['has_unit'] == 1) {
              // print(_listAttributes[mainIndex]['unit_id']);
              _buildMap(_listAttributes[mainIndex]['id'], val,
                  unitID: _listAttributes[mainIndex]['unit_id']);
            } else {
              _buildMap(
                _listAttributes[mainIndex]['id'],
                val,
              );
            }
            // // print("s-n-y:  ${_listAttributes[mainIndex]['id']}");

            // // print("sss");
            // // print(myAdAttributesArray);
            // // print('MYCAT:$myAdAttributes');
          },
          label: _listAttributes[mainIndex]['label'][_lang].toString(),
          textInputType: TextInputType.text),
    );
  }

  buildMultiSelected(mainIndex) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            flex: 14,
            child: Container(
              height: _options.length <= 4
                  ? MediaQuery.of(context).size.height * 0.08
                  : null,
              child: Scrollbar(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 30),
                  shrinkWrap: true,
                  children: _options
                      .map((item) => _buildItem(item, mainIndex))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildSelect(int rcsIndex, int mainIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    if (trendIndex == -1) {
      _buildMap(_listAttributes[mainIndex]['id'],
          _listAttributes[mainIndex]['options'][0]['id']);
      trendIndex = myAdAttributesArray
          .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    }

    var val = "";
    return Container(
      width: 373.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              padding: const EdgeInsets.only(bottom: 200, top: 10),
              alignedDropdown: true,
              child: DropdownButton<String>(
                isExpanded: true,
                value: myAdAttributesArray[trendIndex]['value'].toString(),
                // value: '1',
                iconSize: 30,
                // icon: (null),
                style: appStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                // hint: Text(
                //   "_options[rcsIndex]['label'][_lang].toString()",
                //   style: appStyle(
                //     fontSize: 16,
                //   ),
                // ),
                onChanged: (value) {
                  setState(() {
                    // myAdAttributesArray[_listAttributes[mainIndex]['id']]['value'] = value;
                    _listAttributes[mainIndex]['value'] = value;
                    // // print("select:  ${_listAttributes[mainIndex]['id']}");

                    // List newOp = _listAttributes[mainIndex]['options'];
                    // newOp = newOp
                    //     .where((element) => element['id'].toString() == value)
                    //     .toList();

                    // // print(newOp[rcsIndex]['id']);
                    // // print(_listAttributes[mainIndex]['options'] );
                    // val = newOp[rcsIndex]['label'][_lang];
                    _buildMap(_listAttributes[mainIndex]['id'], value);
                    // testID = value;
                    // print("$myAdAttributesArray");
                  });
                },
                items: _listAttributes[mainIndex]['options']
                        .map<DropdownMenuItem<String>>((listOptions) {
                      return new DropdownMenuItem(
                        child: new Text(
                            val == "" ? "${listOptions['label'][_lang]}" : val),
                        value: listOptions['id'].toString(),
                      );
                    })?.toList() ??
                    [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CheckboxListTile _buildCheckbox(int mainIndex, int rcsIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    if (trendIndex == -1) {
      myAdAttributes[_listAttributes[mainIndex]['name']] = [];
    }

    return CheckboxListTile(
        value: myAdAttributes[_listAttributes[mainIndex]['name']]
            .contains(_listAttributes[mainIndex]['options'][rcsIndex]['id']),
        title: new Text(
            "${_listAttributes[mainIndex]['options'][rcsIndex]['label'][_lang]}"),
        controlAffinity: ListTileControlAffinity.leading,
        tristate: true,
        onChanged: (bool val) {
          setState(() {
            myAdAttributes[_listAttributes[mainIndex]['name']].contains(
                    _listAttributes[mainIndex]['options'][rcsIndex]['id'])
                ? myAdAttributes[_listAttributes[mainIndex]['name']].remove(
                    _listAttributes[mainIndex]['options'][rcsIndex]['id'])
                : myAdAttributes[_listAttributes[mainIndex]['name']]
                    .add(_listAttributes[mainIndex]['options'][rcsIndex]['id']);
            _buildMap(_listAttributes[mainIndex]['id'],
                myAdAttributes[_listAttributes[mainIndex]['name']]);
            // print(myAdAttributesArray);
          });
        });
  }

  Row _buildRadio(int mainIndex, int rcsIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    if (trendIndex == -1) {
      _buildMap(_listAttributes[mainIndex]['id'],
          _listAttributes[mainIndex]['options'][0]['id']);
      trendIndex = myAdAttributesArray
          .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<dynamic>(
          focusColor: Colors.white,
          groupValue: myAdAttributesArray[trendIndex]['value'],
          onChanged: (dynamic newValue) {
            var isValid = _formKey.currentState.validate();
            final inData = ["13,14,15"];
            if (inData.contains(newValue)) {
              setState(() {
                isValid = true;
                print('TRUE STATE $isValid');
              });
            } else {
              setState(() {
                isValid = false;
                print('FALSE STATE');
              });
            }
            // _buildMap(_listAttributes[mainIndex]["id"], newValue);
            setState(() {
              _listAttributes[mainIndex]['value'] = newValue;
              // _listAttributes[mainIndex]['name'] = newValue;
              _buildMap(_listAttributes[mainIndex]['id'], newValue);
              // // print("radio:  ${_listAttributes[mainIndex]['id']}");
              // // print("radio:  ${myAdAttributesArray}");
              // // print(_options[index]['label'][_lang]);
              // // print(list['name']);
            });
          },
          value: _options[rcsIndex]['id'],
        ),
        Text(
          _options[rcsIndex]['label'][_lang],
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        ),
      ],
    );
  }

  _buildPath() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: buildTxt(
                          fontSize: 17,
                          maxLine: 1,
                          txtColor: AppColors.blackColor2,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          txt: "${widget.section}",
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.grey,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: buildTxt(
                          fontSize: 17,
                          maxLine: 1,
                          txtColor: AppColors.blackColor2,
                          fontWeight: FontWeight.w400,
                          txt: "${_adForm[0]['responseData']['label']['ar']}",
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  // Container _buildPath(MediaQueryData mq) {
  //   return Container(
  //     height: mq.size.height * 0.1,
  //     child: Card(
  //       margin: EdgeInsets.only(bottom: 20.0),
  //       elevation: 7,
  //       shadowColor: AppColors.grey,
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Row(
  //           children: [
  //             Text(
  //               "${widget.section}",
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //             ),
  //             SizedBox(
  //               width: 25,
  //               child: Icon(
  //                 Icons.arrow_forward_ios,
  //                 size: 14,
  //                 color: AppColors.grey,
  //               ),
  //             ),
  //             Text(
  //               "${_adForm[0]['responseData']['label']['ar']}",
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Container _buildButton(BuildContext context) {
    // // print("AT:$myAdAttributes");
    return Container(
      child: myButton(
        context: context,
        height: 50,
        width: double.infinity,
        btnTxt: _strController.postAd,
        fontSize: 20,
        txtColor: AppColors.whiteColor,
        radius: 10,
        btnColor: AppColors.redColor,
        onPressed: () {
          print(double.parse(_priceController.text.toString()));
          final FormState form = _formKey.currentState;
          if (form.validate()) {
            addAdFunction(
                context: context,
                sectionId: widget.sectionId.toString(),
                subSectionId: '${widget.subSectionId.toString()}',
                title: _titleController.text.toString(),
                bodyAd: _bodyController.text.toLowerCase(),
                cityId: _cityId,
                price: _priceController.text.toString().isNotEmpty
                    ? double.parse(_priceController.text.toString())
                    : 0,
                localityId: '1',
                lat: _selectedLocation != null
                    ? '${_selectedLocation.latitude}'
                    : "",
                lag: _selectedLocation != null
                    ? '${_selectedLocation.longitude}'
                    : "",
                brandId: _brandId != null ? _brandId : "",
                subBrandId: _subBrandId != null ? _subBrandId : "",
                isDelivery: true,
                isFree: _isFree,
                showContact: _showContactInfo,
                negotiable: _negotiable,
                zoom: 14,
                adAttributes: myAdAttributesArray,
                images: _images != null ? _images : [],
                currencyId: _currencyId);
          } else {
            print('Form is invalid');
            viewToast(
                context, 'Form is invalid', AppColors.redColor, Toast.BOTTOM);
          }

          // _validateAndSubmit();
        },
      ),
    );
  }

  _buildConstData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _strController.selectCity,
          style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: Container(
            width: 395.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                        isExpanded: false,
                        value: _cityId,
                        validator: (value) =>
                            (_cityId == null || _cityId.isEmpty)
                                ? "يجب اختيار المدينه"
                                : null,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text(
                          _cityId != null
                              ? _cityId.toString()
                              : _strController.selectCity,
                          style: appStyle(fontSize: 16),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _cityId = value;
                          });
                        },
                        items: _citiesData.map((listCity) {
                              return new DropdownMenuItem(
                                child: new Text(
                                  listCity['label'][_lang],
                                  style: appStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                value: listCity['id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strController.adTitle,
                style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                child: buildTextField(
                    validator: (value) => (_titleController.text == null ||
                            _titleController.text.isEmpty)
                        ? "يجب اختيار عنوان"
                        : null,
                    label: _strController.adTitle,
                    controller: _titleController,
                    textInputType: TextInputType.text),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strController.adDescription,
                style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                child: buildTextField(
                  validator: (value) => (_bodyController.text == null ||
                          _bodyController.text.isEmpty)
                      ? "يجب اختيار _bodyController"
                      : null,
                  label: _strController.adDescription,
                  controller: _bodyController,
                  minLines: 4,
                  textInputType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
        if (_adForm[0]['responseData']['has_price'])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _strController.price,
                      style:
                          appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      width: 399.0,
                      child: buildTextField(
                          validator: (value) =>
                              (_priceController.text == null ||
                                      _priceController.text.toString().isEmpty)
                                  ? "يجب اختيار price"
                                  : null,
                          label: _strController.price,
                          controller: _priceController,
                          textInputType: TextInputType.number),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _strController.currencies,
                      style:
                          appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      width: 395.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: false,
                                  value: _currencyId,
                                  iconSize: 30,
                                  icon: (null),
                                  validator: (value) => (_currencyId == null ||
                                          _currencyId.isEmpty)
                                      ? "يجب اختيار _currencyId"
                                      : null,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    _currencyId.toString(),
                                    style: appStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _currencyId = value;
                                    });
                                  },
                                  items: _currenciesData.map((listCurrency) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            listCurrency['currency_label']
                                                [_lang],
                                            style: appStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          value: listCurrency['id'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (!widget.fromEdit && _adForm[0]['responseData']['has_brand'])
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "النوع",
                  style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: false,
                              value: _brandId,
                              validator: (value) =>
                                  (_brandId == null || _brandId.isEmpty)
                                      ? "يجب اختيار _brandId"
                                      : null,
                              iconSize: 30,
                              icon: (null),
                              style: appStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text(
                                // _brandId!=null?_brandId.toString():"choose type",
                                _listBrands[0]['label'][_lang],
                                style: appStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  _subBrandId = null;
                                  _brandId = value;
                                  _listSubBrands = _listBrands
                                      .where((element) =>
                                          element['id'].toString() ==
                                          value.toString())
                                      .toList();
                                  _listSubBrands =
                                      _listSubBrands[0]['sub_brands'];
                                  _listSubBrands =
                                      _listSubBrands.toSet().toList();
                                  if (_listSubBrands != [] &&
                                      _listSubBrands != null &&
                                      _listSubBrands.isNotEmpty) {
                                    setState(() {
                                      hasSubBrands = true;
                                    });
                                  } else {
                                    setState(() {
                                      hasSubBrands = false;
                                    });
                                  }
                                });
                              },
                              items: _listBrands.map((listBrand) {
                                    // // print("LIST BRAND ${listBrand['id']}");
                                    return new DropdownMenuItem(
                                      child: new Text(
                                        listBrand['label'][_lang],
                                        style: appStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      value: listBrand['id'].toString(),
                                    );
                                  })?.toList() ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasSubBrands == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                      width: 382.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: false,
                                  value: _subBrandId,
                                  validator: (value) => (_subBrandId == null ||
                                          _subBrandId.isEmpty)
                                      ? "يجب اختيار _subBrandId"
                                      : null,
                                  iconSize: 30,
                                  icon: (null),
                                  style: appStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    // _subBrandId!=null?_subBrandId.toString():"choose sub type",
                                    _listSubBrands[0]['label'][_lang],
                                    style: appStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _subBrandId = value;
                                      // myAdAttributes[_listSubBrands[index]['name']] = value;
                                      // test(_listSubBrands[index]['id'], value);

                                      // // print(" typeee ${value}");
                                    });
                                  },
                                  items: _listSubBrands.map((listSubBrand) {
                                        // // print("LIST BRAND ${listSubBrand['id']}");
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            listSubBrand['label'][_lang],
                                            style: appStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          value: listSubBrand['id'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MergeSemantics(
                      child: ListTile(
                        title: Text(
                          _strController.showContactInfo,
                          style: appStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: CupertinoSwitch(
                          value: _showContactInfo,
                          onChanged: (bool value) {
                            setState(() {
                              _showContactInfo = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _showContactInfo = !_showContactInfo;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        if (_adForm[0]['responseData']['is_delivery'])
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTxt(
                            txt: _strController.withDelivery,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        Transform.scale(
                          scale: 1.4,
                          child: Checkbox(
                            value: _isDelivery,
                            onChanged: (value) {
                              setState(() {
                                _isDelivery = value;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            tristate: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strController.video,
                style: appStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                child: buildTextField(
                    suffixIcon: Icon(
                      FontAwesomeIcons.youtube,
                      color: Colors.red,
                      size: 16,
                    ),
                    fromPhone: true,
                    label: _strController.video,
                    controller: _videoController,
                    textInputType: TextInputType.text),
              ),
            ],
          ),
        ),
        if (_adForm[0]['responseData']['has_map'])
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text(
                  "Pick a Location",
                  style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () {
                  double latitude = _selectedLocation != null
                      ? _selectedLocation.latitude
                      : SLPConstants.DEFAULT_LATITUDE;
                  double longitude = _selectedLocation != null
                      ? _selectedLocation.longitude
                      : SLPConstants.DEFAULT_LONGITUDE;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SimpleLocationPicker(
                                zoomLevel: 18,
                                markerColor: AppColors.grey,
                                displayOnly: false,
                                appBarTextColor: AppColors.blackColor,
                                appBarColor: AppColors.whiteColor,
                                initialLatitude: latitude,
                                initialLongitude: longitude,
                                appBarTitle: "Select Location",
                              ))).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    }
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  void _onCancelTap() {}

  void _onSubmitTap() {}

  void _onItemCheckedChange(itemValue, bool checked, attributeId) {
    setState(() {
      if (checked) {
        myAdAttributesMulti.add(itemValue);
      } else {
        myAdAttributesMulti.remove(itemValue);
      }

      _buildMap(attributeId, myAdAttributesMulti);
      // print(myAdAttributesArray);
    });
  }

  Widget _buildItem(item, mainIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    var checked = false;
    if (trendIndex != -1) {
      myAdAttributesMulti = myAdAttributesArray[trendIndex]['value'];
      checked = myAdAttributesArray[trendIndex]['value'].contains(item['id']);
    }

    return CheckboxListTile(
      value: checked,
      // subtitle: !false
      //     ? Padding(
      //   padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
      //   child: Text('Required field', style: TextStyle(color: Color(0xFFe53935), fontSize: 12),),)
      //     : null,
      title: Text(item['label'][_lang]),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        // print('_lang : ${item['label'][_lang]}');
        _onItemCheckedChange(
            item['id'], checked, _listAttributes[mainIndex]['id']);
      },
    );
  }

// void _validateAndSubmit(bool isRequired,String validationType) {
//   final isValid  = _formKey.currentState;
//   if(validationType == 'radio')
//   if (form.validate()) {
//
//   }
// }

}

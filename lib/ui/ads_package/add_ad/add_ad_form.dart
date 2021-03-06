import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/user_panel.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:simple_location_picker/simple_location_picker_screen.dart';
// import 'package:simple_location_picker/simple_location_result.dart';
// import 'package:simple_location_picker/utils/slp_constants.dart';
import 'package:toast/toast.dart';

import '../public_ads_screen.dart';

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
  bool _negotiableVis = true;
  bool _isDeliveryVis = true;
  bool _isFree = false;
  bool _isFreeVis = true;
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

  // SimpleLocationResult _selectedLocation;
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
  List<dynamic> _images = [];

  List<dynamic> pickedImages = [];
  String _type;
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
  double latitudeData;
  double longitudeData;
  GlobalKey<ProgressHudState> _hudKey = GlobalKey();

  Future getCurrentLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData = geoPosition.latitude;
      longitudeData = geoPosition.longitude;
      _loading = false;
    });
    return geoPosition;
  }

  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 18,
  );

  Address address;

  var textController = TextEditingController();

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

  bool _showMap = false;

  _buildImagesMap(
      {String imgName = '',
      bool isNew = true,
      bool isDeleted = false,
      bool isMain = false,
      String identifier = ''}) {
    pickedImages.add({
      'new': isNew,
      'deleted': isDeleted,
      'main': isMain,
      'name': imgName,
      'identifier': identifier
    });
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

  String _customMessage = '';
  int _code = 0;

  @override
  void initState() {
    // // print('adID : ${widget.adID}');
    getLang();
    pickedImages = [];
    _images = [];
    _getCountries();
    myAdAttributesArray = [];
    myAdAttributes = {};
    myAdAttributesMulti = [];
    AdAddForm.getAdsForm(subSectionId: widget.subSectionId.toString())
        .then((value) {
      if (value[0] == 412) {
        setState(() {
          print('value: $value');
          _customMessage = value[1];
          _code = value[0];
          _loading = false;
        });
      } else
        setState(() {
          print('value: $value');
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
          _negotiableVis = value[0]['responseData']['negotiable'];
          _isFreeVis = value[0]['responseData']['is_free'];
          _isDeliveryVis = value[0]['responseData']['is_delivery'];
          _loading = false;
          var _dataCurrency = _currenciesData
              .where((element) => element['default'] == true)
              .toList();
          _currencyId = _dataCurrency[0]['id'].toString();
          getCurrentLocation().then((value) {
            // print(" latitudeData : $latitudeData");
            // print(" longitudeData : $longitudeData");
          });
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
      appBar: _showMap ? null : defaultAppbar(context, _strController.addAd),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? Center(child: buildLoading(color: AppColors.redColor))
            : _showMap
                ? Container(
                    child: Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: MapPicker(
                              // pass icon widget
                              iconWidget: Icon(
                                Icons.location_pin,
                                size: 50,
                              ),
                              //add map picker controller
                              mapPickerController: mapPickerController,
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                // hide location button
                                myLocationButtonEnabled: false,
                                mapType: MapType.normal,
                                //  camera position
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(latitudeData, longitudeData),
                                  zoom: 18,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                onCameraMoveStarted: () {
                                  // notify map is moving
                                  mapPickerController.mapMoving();
                                },
                                onCameraMove: (cameraPosition) {
                                  this.cameraPosition = cameraPosition;
                                },
                                onCameraIdle: () async {
                                  // notify map stopped moving
                                  mapPickerController.mapFinishedMoving();
                                  //get address name from camera position
                                  List<Address> addresses = await Geocoder.local
                                      .findAddressesFromCoordinates(Coordinates(
                                          cameraPosition.target.latitude,
                                          cameraPosition.target.longitude));
                                  // print("cameraPosition.target.latitude");
                                  // print(cameraPosition.target.latitude);
                                  // print("cameraPosition.target.longitude");
                                  // print(cameraPosition.target.longitude);
                                  // update the ui with the address
                                  textController.text =
                                      '${addresses.first?.addressLine ?? ''}';
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _code != 412
                    ? ProgressHud(
                        isGlobalHud: true,
                        key: _hudKey,
                        child: Directionality(
                          textDirection: AppController.textDirection,
                          child: LayoutBuilder(
                            builder: (ctx, constraints) => Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!widget.fromEdit) _buildPath(),
                                      _buildImages(),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildConstData(mq),
                                      ),
                                      _buildDynamicData(mq),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _buildButton(context, ctx),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.redColor,
                                        offset: Offset(2, 2),
                                        blurRadius: 1,
                                        spreadRadius: 2)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: AppColors.whiteColor,
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: buildTxt(
                                            txt: "$_customMessage",
                                            maxLine: 4,
                                            txtColor: AppColors.whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            textAlign: TextAlign.center),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
      ),
      bottomNavigationBar: !_showMap
          ? null
          : BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                color: Colors.blue,
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  controller: textController,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                // icon: Icon(Icons.directions_boat),
              ),
            ),
      floatingActionButton: _showMap
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _showMap = false;
                });
              },
              label: Text(_strController.done),
              icon: Icon(Icons.done),
            )
          : null,
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
            _listUnits = _listAttributes[mainIndex]['units'];
            _options = _listAttributes[mainIndex]['options'];
            _type = _listAttributes[mainIndex]['config']['type'];
            return buildMainAttributes(mainIndex, mq);
          }),
    );
  }

  Padding buildMainAttributes(int mainIndex, MediaQueryData mq) {
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
            _buildSNY(mainIndex, mq),
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
                          _buildUnits(_listUnits, unitIndex, mainIndex, mq),
                    ],
                  );
                }),
          if (_type == 'dob')
            myButton(
                fontSize: 16,
                height: 45,
                onPressed: () {
                  // print("${_listAttributes[mainIndex]['value']}");
                  _pickDateDialog(_listAttributes[mainIndex]['id'], value: "");
                },
                radius: 10,
                btnTxt: chosenDate,
                txtColor: Colors.black54,
                btnColor: Colors.white),
          if (_type == 'checkbox' ||
              _type == 'radio' ||
              _type == 'select' ||
              _type == 'multiple_select' ||
              _type == 'buttons_groups' ||
              _type == 'multiple_buttons_groups' ||
              _type == 'color' ||
              _type == 'multiple_color')
            Container(
              decoration: BoxDecoration(
                  border: _type == 'radio' ||
                          _type == 'color' ||
                          _type == 'checkbox' ||
                          _type == 'multiple_color' ||
                          _type == 'multiple_select'
                      ? Border.all(color: Colors.grey)
                      : null,
                  borderRadius: _type == 'select'
                      ? BorderRadius.circular(8)
                      : BorderRadius.circular(4)),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent:
                          _type == 'radio' || _type == 'color' ? 50 : null,
                      childAspectRatio: _type == 'select'
                          ? 7
                          : (_type == 'multiple_color')
                              ? 2
                              : 3,
                      crossAxisCount: _type == 'select'
                          ? 1
                          : _type == 'color' || _type == 'multiple_color'
                              ? 3
                              : 2),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _type == 'select' ? 1 : _options.length,
                  itemBuilder: (context, rcsIndex) {
                    return Container(
                      decoration: BoxDecoration(
                          // border: _type == 'radio' || _type == 'checkbox'?Border.all(color: Colors.grey):null,
                          borderRadius: _type == 'select'
                              ? BorderRadius.circular(8)
                              : BorderRadius.circular(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (_type == 'radio' || _type == 'color')
                            Container(
                              child: _buildRadio(mainIndex, rcsIndex,
                                  type: _type.toString()),
                            ),
                          if (_type == 'checkbox' ||
                              _type == 'buttons_groups' ||
                              _type == 'multiple_select' ||
                              _type == 'multiple_color' ||
                              _type == 'multiple_buttons_groups')
                            _buildCheckbox(mainIndex, rcsIndex),
                          if (_type == 'select')
                            _buildSelect(rcsIndex, mainIndex, mq),
                          // if (_type == 'multiple_color')
                          //     buildMultiSelected(mainIndex, mq,type: _type),
                        ],
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }

  Container _buildUnits(
      List _listUnits, int unitIndex, int mainIndex, MediaQueryData mq) {
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
      width: mq.size.width,
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

  Container _buildSNY(int mainIndex, MediaQueryData mq) {
    var initialValue = '';

    return Container(
      width: mq.size.width,
      child: buildTextField(
          initialValue: initialValue,
          fromAttributes: true,
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
          },
          label: _listAttributes[mainIndex]['label'][_lang].toString(),
          textInputType: TextInputType.text),
    );
  }

  buildMultiSelected(mainIndex, MediaQueryData mq, {String type}) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // height: _options.length <= 4 ?   MediaQuery.of(context).size.height*0.04 :  null,

                child: Scrollbar(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 40),
                    shrinkWrap: true,
                    children: _options
                        .map((item) => _buildItem(item, mainIndex, type: type))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSelect(int rcsIndex, int mainIndex, MediaQueryData mq) {
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
      width: mq.size.width,
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
                    print("$myAdAttributesArray");
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
    var _name = _listAttributes[mainIndex]['options'][rcsIndex];
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    if (trendIndex == -1) {
      myAdAttributes[_listAttributes[mainIndex]['name']] = [];
    }

    return CheckboxListTile(
        value: myAdAttributes[_listAttributes[mainIndex]['name']]
            .contains(_listAttributes[mainIndex]['options'][rcsIndex]['id']),
        title: _options[rcsIndex]['name'] == 'other'
            ? CircleAvatar(
                backgroundColor: AppColors.whiteColor,
                radius: 15,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.yellow,
                          Colors.red,
                          Colors.yellow,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greyFour,
                            offset: Offset(0.4, 0.4),
                            spreadRadius: 0.4,
                            blurRadius: 0.4)
                      ]),
                ),
              )
            : _type != 'multiple_color'
                ? Text(
                    _name['label'][_lang],
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                  )
                : CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.whiteColor,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Color(
                            int.parse(_name['name'].replaceAll('#', '0xFF')),
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.greyFour,
                                offset: Offset(0.4, 0.4),
                                spreadRadius: 0.4,
                                blurRadius: 0.4)
                          ]),
                    ),
                  ),

        // new Text(
        //     "${_listAttributes[mainIndex]['options'][rcsIndex]['label'][_lang]}"),
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
            print(myAdAttributesArray);
          });
        });
  }

  Row _buildRadio(int mainIndex, int rcsIndex, {String type}) {
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
            // final inData = ["13,14,15"];
            // if (inData.contains(newValue)) {
            //   setState(() {
            //     isValid = true;
            //     print('TRUE STATE $isValid');
            //   });
            // } else {
            //   setState(() {
            //     isValid = false;
            //     print('FALSE STATE');
            //   });
            // }
            // _buildMap(_listAttributes[mainIndex]["id"], newValue);
            setState(() {
              _listAttributes[mainIndex]['value'] = newValue;
              // _listAttributes[mainIndex]['name'] = newValue;
              _buildMap(_listAttributes[mainIndex]['id'], newValue);
              // // print("radio:  ${_listAttributes[mainIndex]['id']}");
              // // print("radio:  ${myAdAttributesArray}");
              // // print(_options[index]['label'][_lang]);
              // // print(list['name']);
              print("$myAdAttributesArray");
            });
          },
          value: _options[rcsIndex]['id'],
        ),
        if (_options[rcsIndex]['name'] == 'other')
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.red,
                    Colors.yellow,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.greyFour,
                      offset: Offset(0.4, 0.4),
                      spreadRadius: 0.4,
                      blurRadius: 0.4)
                ]),
          ),
        if (_options[rcsIndex]['name'] != 'other')
          type == 'radio'
              ? Text(
                  _options[rcsIndex]['label'][_lang],
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                )
              : Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                            _options[rcsIndex]['name'].replaceAll('#', '0xFF')),
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greyFour,
                            offset: Offset(0.4, 0.4),
                            spreadRadius: 0.4,
                            blurRadius: 0.4)
                      ]),
                ),
      ],
    );
  }

  _buildPath() {
    return _loading
        ? buildLoading(color: AppColors.green)
        : Padding(
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
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: buildTxt(
                              fontSize: 17,
                              maxLine: 2,
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
                              maxLine: 2,
                              txtColor: AppColors.blackColor2,
                              fontWeight: FontWeight.w400,
                              txt:
                                  "${_adForm[0]['responseData']['label']['ar']}",
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

  _buildButton(BuildContext context, ctx) {
    // // print("AT:$myAdAttributes");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
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
            final FormState form = _formKey.currentState;
            pickedImages.where((pickedImagesElement) {
              if (!_images.contains(pickedImagesElement['identifier'])) {
                pickedImagesElement['deleted'] = true;
              }
              return true;
            }).toList();

            print(pickedImages.length.toString());
            print(pickedImages
                .where((element) => element['deleted'])
                .toList()
                .length);
            if (form.validate()) {
              showLoadingHud(context: ctx, hudKey: _hudKey, time: 5000);

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
                      lat: latitudeData.toString(),
                      lag: longitudeData.toString(),
                      brandId: _brandId != null ? _brandId : "",
                      subBrandId: _subBrandId != null ? _subBrandId : "",
                      isDelivery: true,
                      isFree: _isFree,
                      showContact: _showContactInfo,
                      negotiable: _negotiable,
                      zoom: true,
                      video: _videoController.text.toString(),
                      adAttributes: myAdAttributesArray,
                      images: pickedImages != null ? pickedImages : [],
                      currencyId: _currencyId)
                  .then((value) {
                if (value == 200)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPanel(),
                    ),
                  );
              });
            } else {
              print('Form is invalid');
              viewToast(
                  context, 'Form is invalid', AppColors.redColor, Toast.BOTTOM);
            }

            // _validateAndSubmit();
          },
        ),
      ),
    );
  }

  _buildConstData(MediaQueryData mq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _strController.selectCity,
          style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 20, top: 10, left: 3, right: 3),
          child: Container(
            width: mq.size.width,
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
                        validator: validateCity,
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
                            // log('_cityId : $_citiesData');
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
                    validator: validateTitle,
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
                  validator: validateBody,
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
                      width: mq.size.width,
                      child: buildTextField(
                          label: _strController.price,
                          controller: _priceController,
                          textInputType: TextInputType.number),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _strController.currencies,
                        style:
                            appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        width: mq.size.width,
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
                                    validator: validateCurrency,
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
                                            value:
                                                listCurrency['id'].toString(),
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
                  "??????????",
                  style: appStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
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
                                        ? "?????? ???????????? _brandId"
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                ),
                if (hasSubBrands == true)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 3, right: 3),
                    child: Container(
                      width: mq.size.width,
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
                                      ? "?????? ???????????? _subBrandId"
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
              Column(
                children: [
                  MergeSemantics(
                    child: ListTile(
                      title: Text(
                        _strController.showContactInfo,
                        style:
                            appStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  if (_isFreeVis)
                    MergeSemantics(
                      child: ListTile(
                        title: Text(
                          _strController.free,
                          style: appStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: CupertinoSwitch(
                          value: _isFree,
                          onChanged: (bool value) {
                            setState(() {
                              _isFree = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _isFree = !_isFree;
                          });
                        },
                      ),
                    ),
                  if (_negotiableVis)
                    MergeSemantics(
                      child: ListTile(
                        title: Text(
                          _strController.negotiable,
                          style: appStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: CupertinoSwitch(
                          value: _negotiable,
                          onChanged: (bool value) {
                            setState(() {
                              _negotiable = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _negotiable = !_negotiable;
                          });
                        },
                      ),
                    ),
                  if (_isDeliveryVis)
                    MergeSemantics(
                      child: ListTile(
                        title: Text(
                          _strController.negotiable,
                          style: appStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: CupertinoSwitch(
                          value: _negotiable,
                          onChanged: (bool value) {
                            setState(() {
                              _negotiable = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _negotiable = !_negotiable;
                          });
                        },
                      ),
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 1),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: RaisedButton(
                color: AppColors.greyFour,
                child: Text(
                  "???????? ?????????? ????????????",
                  style: appStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.whiteColor),
                ),
                onPressed: () {
                  setState(() {
                    _showMap = true;
                  });
                  // double latitude = _selectedLocation != null
                  //     ? _selectedLocation.latitude
                  //     : SLPConstants.DEFAULT_LATITUDE;
                  // double longitude = _selectedLocation != null
                  //     ? _selectedLocation.longitude
                  //     : SLPConstants.DEFAULT_LONGITUDE;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SimpleLocationPicker(
                  //               zoomLevel: 18,
                  //               markerColor: AppColors.grey,
                  //               displayOnly: false,
                  //               appBarTextColor: AppColors.blackColor,
                  //               appBarColor: AppColors.whiteColor,
                  //               // initialLatitude: latitude,
                  //               // initialLongitude: longitude,
                  //               appBarTitle: "Select Location",
                  //             ))).then((value) {
                  //   if (value != null) {
                  //     setState(() {
                  //       _selectedLocation = value;
                  //     });
                  //   }
                  // });
                },
              ),
            ),
          ),
      ],
    );
  }

  void _onItemCheckedChange(itemValue, bool checked, attributeId) {
    setState(() {
      if (checked) {
        myAdAttributesMulti.add(itemValue);
        print("$myAdAttributesArray");
      } else {
        myAdAttributesMulti.remove(itemValue);
        print("$myAdAttributesArray");
      }

      _buildMap(attributeId, myAdAttributesMulti);
      // print(myAdAttributesArray);
    });
  }

  Widget _buildItem(item, mainIndex, {String type}) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    var checked = false;
    if (trendIndex != -1) {
      myAdAttributesMulti = myAdAttributesArray[trendIndex]['value'];
      checked = myAdAttributesArray[trendIndex]['value'].contains(item['id']);
    }

    return CheckboxListTile(
      value: checked,
      title: item['name'] != 'other'
          ? type == 'multiple_select' || type == 'multiple_color'
              ? Text(
                  item['label'][_lang],
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                )
              : Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Color(
                        int.parse(item['name'].replaceAll('#', '0xFF')),
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greyFour,
                            offset: Offset(0.4, 0.4),
                            spreadRadius: 0.4,
                            blurRadius: 0.4)
                      ]),
                )
          : CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.whiteColor,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.red,
                        Colors.green,
                        Colors.yellow,
                        Colors.red,
                        Colors.yellow,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.greyFour,
                          offset: Offset(0.4, 0.4),
                          spreadRadius: 0.4,
                          blurRadius: 0.4)
                    ]),
              ),
            ),

      // Text(item['label'][_lang]),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        // print('_lang : ${item['label'][_lang]}');
        _onItemCheckedChange(
            item['id'], checked, _listAttributes[mainIndex]['id']);
      },
    );
  }

  List<Asset> images = List<Asset>();
  List files = [];
  List<Asset> resultList;
  String _error = 'No Error Dectected';

  Widget buildListViewImages() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        Asset asset = images[index];
        var lastImages = [];
        images.forEach((element) {
          lastImages.add(element.identifier);
        });
        _images = lastImages;
        print("_images ${_images.length}");
        FlutterAbsolutePath.getAbsolutePath(images[index].identifier)
            .then((value) async {
          print('val: $value');
          var path2 = await FlutterAbsolutePath.getAbsolutePath(
              images[index].identifier);
          var file = await getImageFileFromAsset(path2);
          String fileExt = path2.split('/').last;
          fileExt = fileExt.split('.').last;
          var base64Image =
              "data:image/$fileExt;base64,${base64Encode(file.readAsBytesSync())}";

          var alreadyChoose = pickedImages.where(
              (element) => element['identifier'] == images[index].identifier);
          if (alreadyChoose.length == 0) {
            await uploadImage(context, base64Image).then((value) {
              _buildImagesMap(
                  isMain: index == 0 ? true : false,
                  imgName: value[0]['responseData']['image'],
                  identifier: images[index].identifier);
            });
            print(pickedImages);
          }
        });
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              AssetThumb(
                asset: asset,
                width: 200,
                height: 200,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    child: buildIcons(
                        iconData: Icons.delete_forever,
                        color: Colors.red,
                        bgColor: AppColors.whiteColor.withOpacity(0.6),
                        height: 35,
                        width: 35),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
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
      // print('resultList: $resultList');
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      print('images: $images');
      _error = error;
    });
  }

  Widget _buildImages() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Center(child: Text('Error: $_error')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("???????? ??????"),
              onPressed: loadAssets,
            ),
          ),
        ),
        // if (files.isNotEmpty)
        if (images.length != 0)
          SizedBox(height: 120, child: buildListViewImages()),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

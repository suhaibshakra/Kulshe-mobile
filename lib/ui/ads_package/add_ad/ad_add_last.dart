import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class AddAdDataScreen extends StatefulWidget {
  final section;
  final sectionId;
  final subSectionId;

  AddAdDataScreen({this.section, this.sectionId, this.subSectionId});

  @override
  _AddAdDataScreenState createState() => _AddAdDataScreenState();
}

class _AddAdDataScreenState extends State<AddAdDataScreen> {
  String _lang;
  bool _negotiable = false;
  String _free;
  bool _showContactInfo = true;
  bool _isFree = false;
  bool _isDelivery = false;
  bool _loading = true;
  TextEditingController _titleController = TextEditingController()..text;
  TextEditingController _priceController = TextEditingController()..text;
  TextEditingController _videoController = TextEditingController()..text;
  TextEditingController _addBody = TextEditingController()..text;
  TextEditingController _birthDateController = TextEditingController()..text;
  List _adForm;
  List _countryData;
  List _citiesData;
  String _cityId;
  List _currenciesData;
  List _listAttributes;
  SimpleLocationResult _selectedLocation;
  String cityID;
  String currencyID;
  String testID;
  double value = 50.0;
  DateTime _selectedDate;

  var attributes = [];

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _birthDateController.text = DateFormat.yMMMd().format(pickedDate);
      });
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
    // print('_${_countryData.where((element) => element.classified == true)}');
    // print(sections[0].responseData[4].name);
  }

  getLang() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = _prefs.getString('lang');
    });
  }

  @override
  void initState() {
    getLang();
    _getCountries();
    print(widget.section);
    AdAddForm.getAdsForm(subSectionId: widget.subSectionId.toString())
        .then((value) {
      setState(() {
        _adForm = value;
        _currenciesData = value[0]['responseData']['currencies'];
        _listAttributes = value[0]['responseData']['attributes'];
        _showContactInfo = value[0]['responseData']['show_my_contact'];
        _negotiable = value[0]['responseData']['negotiable'];
        _isFree = value[0]['responseData']['if_free'];
        _loading = false;
        var _dataCurrency = _currenciesData
            .where((element) => element['default'] == true)
            .toList();
        currencyID = _dataCurrency[0]['id'].toString();
        // print('_listAttributes  : $_listAttributes');
        // print('_AD  : $_dataCurrency');
        // print('_AD  : $_dataCurrency');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: AppController.textDirection,
          child: _loading
              ? Center(child: buildLoading(color: AppColors.green))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPath(mq),
                      _buildAttributes(mq, context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Padding _buildAttributes(MediaQueryData mq, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Card(
          elevation: 8,
          shadowColor: AppColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المدينة",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, index) {
                        // print(_adForm[0]['responseData']['attributes'][0]['name']);
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      isExpanded: false,
                                      value: cityID,
                                      iconSize: 30,
                                      icon: (null),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                      hint: Text(
                                        cityID.toString(),
                                        style: appStyle(fontSize: 18),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          cityID = value;
                                          print('Value:$value');
                                        });
                                      },
                                      items: _citiesData.map((listCity) {
                                            return new DropdownMenuItem(
                                              child: new Text(
                                                  listCity['label'][_lang]),
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
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "عنوان الإعلان",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      child: buildTextField(
                          label: "عنوان الإعلان",
                          controller: _titleController,
                          textInputType: TextInputType.text),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (_adForm[0]['responseData']['has_price'])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "السعر",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                            child: buildTextField(
                                label: "السعر",
                                controller: _priceController,
                                textInputType: TextInputType.number),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "العملة",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            isExpanded: false,
                                            value: currencyID,
                                            iconSize: 30,
                                            icon: (null),
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                            ),
                                            hint: Text(
                                              currencyID.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Anton'),
                                            ),
                                            onChanged: (String value) {
                                              setState(() {
                                                currencyID = value;
                                              });
                                            },
                                            items: _currenciesData
                                                    .map((listCurrency) {
                                                  return new DropdownMenuItem(
                                                    child: new Text(listCurrency[
                                                            'currency_label']
                                                        [_lang]),
                                                    value: listCurrency['id']
                                                        .toString(),
                                                  );
                                                })?.toList() ??
                                                [],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                if (_adForm[0]['responseData']['is_free'] ||
                    _adForm[0]['responseData']['negotiable'])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_adForm[0]['responseData']['negotiable'])
                              Container(
                                color: AppColors.whiteColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildTxt(txt: "قابل للتفاوض"),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _negotiable,
                                        onChanged: (value) {
                                          setState(() {
                                            _negotiable = value;
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
                            if (_adForm[0]['responseData']['is_free'])
                              Container(
                                color: AppColors.whiteColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildTxt(txt: "مجانا"),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _isFree,
                                        onChanged: (value) {
                                          setState(() {
                                            _isFree = value;
                                          });
                                        },
                                        activeColor: Colors.green,
                                        checkColor: Colors.white,
                                       ),
                                    ),
                                  ],
                                ),
                              ),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                //attributes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: _listAttributes.length,
                      itemBuilder: (BuildContext context, index) {
                        var _options = _listAttributes[index]['options'];
                        var _type = _listAttributes[index]['config']['type'];
                        return _buildNumTxt(index, _type, _options, mq);
                      },
                    ),
                  ],
                ),
                if (_adForm[0]['responseData']['is_delivery'])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTxt(txt: "مع توصيل ؟"),
                              Transform.scale(
                                scale: 1.2,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "فيديو",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      child: buildTextField(
                          suffix: Icon(
                            FontAwesomeIcons.youtube,
                            color: Colors.red,
                            size: 16,
                          ),
                          fromPhone: true,
                          label: "فيديو",
                          controller: _videoController,
                          textInputType: TextInputType.text),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "وصف الإعلان",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      child: buildTextField(
                          label: "وصف الإعلان",
                          controller: _addBody,
                          textInputType: TextInputType.text),
                    ),
                  ],
                ),
                Column(
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
                                "إظهار معلومات الإتصال",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                if (!_adForm[0]['responseData']['has_map'])
                  RaisedButton(
                    child: Text("Pick a Location"),
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
                SizedBox(
                  height: 30,
                ),
                _buildButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildNumTxt(int index, _type, _options, MediaQueryData mq) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.greyThree, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _listAttributes[index]['label'][_lang].toString(),
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _type.toString(),
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _options.length.toString(),
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            if (_options.length == 0)
              if (_type == 'string')
                Container(
                  height: 45,
                  child: buildTextField(
                      label: _listAttributes[index]['label'][_lang].toString(),
                      controller: _titleController,
                      textInputType: TextInputType.text),
                ),
            if (_type == 'number')
                 Container(
                height: 60,
                child: buildTextField(
                    label: _listAttributes[index]['label'][_lang].toString(),
                    controller: _titleController,
                    textInputType: TextInputType.number),
              ),
            if (_type == 'year')
                 Container(
                height: 60,
                child: buildTextField(
                    label: _listAttributes[index]['label'][_lang].toString(),
                    controller: _titleController,
                    textInputType: TextInputType.number),
              ),

            if (_type == 'dob')
              myButton(
                  fontSize: 16,
                  width: mq.size.width * 0.5,
                  height: 45,
                  onPressed: () => _pickDateDialog(),
                  radius: 10,
                  btnTxt: "Choose Date",
                  txtColor: Colors.black54,
                  btnColor: Colors.white),
            if (_options.length != 0)

                _buildSelectRadioCheckBox(_type, _options,_listAttributes[index])


          ],
        ),
      ),
    );
  }

  Container _buildButton(BuildContext context) {
    return Container(
      child: myButton(
        context: context,
        height: 50,
        width: double.infinity,
        btnTxt: "نشر الإعلان",
        fontSize: 20,
        txtColor: AppColors.whiteColor,
        radius: 10,
        btnColor: AppColors.redColor,
        onPressed: () {
          addAdFunction(
              context: context,
              sectionId: widget.sectionId.toString(),
              subSectionId: '${widget.subSectionId.toString()}',
              title: _titleController.text.toString(),
              bodyAd: _addBody.text.toLowerCase(),
              cityId: '8',
              price:  _priceController.text.toString()!= null?double.parse(_priceController.text.toString()):0,
              localityId: '1',
              lat: '${_selectedLocation.latitude}',
              lag: '${_selectedLocation.longitude}',
              brandId: '1',
              subBrandId: '1',
              isDelivery: true,
              isFree: _isFree,
              showContact: _showContactInfo,
              negotiable: _negotiable,
              zoom: 14,
              adAttributes: [],
              images: [],
              currencyId: '110');
          // _validateAndSubmit();
        },
      ),
    );
  }

  int groupValue = -1;
  Container _buildSelectRadioCheckBox(_type, _options,var list) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _type == 'select' ? 1 : _options.length,
        itemBuilder: (context, index) {
          // print('OPTIONS: $_options');
          List options = _options.toList();
          // print('OPTIONS: $options');
          int id = index;

          // print('ID: $id');
          return Column(
            children: [
              // for (int i=0;i<_options.length;i++)
              if (_type == 'radio')
              //  Row(
              //    children: [
              //      Row(
              //       children: List<Widget>.generate(
              //         1,
              //             (int i) => Radio<int>(
              //           value: i,
              //
              //           groupValue: groupValue,
              //           onChanged: (int value) {
              //             setState(() {
              //               groupValue = value;
              //             });
              //           }
              //         ),
              //       ),
              //
              // ),
              //      Text(
              //        _options[index]['label'][_lang],
              //        style: TextStyle(fontWeight: FontWeight.bold),
              //      ),
              //    ],
              //  ),

                Row(
                  children: <Widget>[
                    Radio<dynamic>(
                      focusColor: Colors.white,
                      groupValue: list['name'],
                      onChanged: (dynamic newValue) {
                        setState(() {
                          list['name'] = newValue;
                        });},
                      value: _options[index]['id'],
                    ),
                    Text(
                      _options[index]['label'][_lang],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (_type == 'checkbox')
                  Container(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTxt(txt: "${_options[index]['label'][_lang]}"),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _negotiable,
                              onChanged: (value) {
                                setState(() {
                                  _negotiable = value;
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
              if (_type == 'select')
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: false,
                              value: testID,
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text(
                                testID.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Anton'),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  testID = value;
                                });
                              },
                              items:_options.map<DropdownMenuItem<String>>((list) {
                                    return new DropdownMenuItem(
                                      child:
                                          new Text( list['label'][_lang] ),
                                      value: list ['id'].toString(),
                                    );
                                  })?.toList()??[] ,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Container _buildPath(MediaQueryData mq) {
    return Container(
      height: mq.size.height * 0.1,
      child: Card(
        elevation: 5,
        shadowColor: AppColors.grey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                "${widget.section}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                width: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.grey,
                ),
              ),
              Text(
                "${_adForm[0]['responseData']['label']['ar']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectiona = 0;
  int _selectionb = 0;

  selectTime(dynamic timeSelected) {
    setState(() {
      _selectiona = timeSelected;
    });
  }
}

// class AllData {
//   static dataType(String type, label) {
//     if (type == 'number') {
//       return buildTextField(label: 'test Label');
//     }
//   }
// }

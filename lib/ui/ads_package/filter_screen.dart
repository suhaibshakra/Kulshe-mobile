import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';
import 'package:kulshe/ui/ads_package/public_ads_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  var sectionId;

  var subSectionId;

  FilterScreen({Key key, this.sectionId, this.subSectionId}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController _fromController = TextEditingController()..text;
  TextEditingController _toController = TextEditingController()..text;
  final _strController = AppController.strings;


  String _brandId;
  String _subBrandId;
  List _sectionData;
  List _subSectionData;
  List _listBrands;
  List _listSubBrands;
  bool hasSubBrands = false;
  List _listAttributes;
  List _options;
  bool _loading = true;
  String _lang;
  String _maxPrice;
  String _type;
  List<dynamic> myAdAttributesArray = []; //edit
  List<dynamic> myAdAttributesMulti = []; //edit
  Map myAdAttributes = {}; //edit
  String countryID;

  _getSections() async {
    
    SharedPreferences _gp = await SharedPreferences.getInstance();
    
    setState(() {
      countryID = _gp.getString('countryId');
    });
    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      setState(() {
        _lang = _gp.getString("lang");
        _sectionData = _sectionData.where((element) => element['id'] == widget.sectionId && (element['sub_sections'].where((i) => i['id'] == widget.subSectionId).toList().length > 0)).toList();
        _subSectionData = _sectionData[0]['sub_sections'].where((element) => (element['id'] == widget.subSectionId)).toList();
        _listAttributes = _subSectionData[0]['attributes'];

        if (_subSectionData[0]['has_brand']) {
         setState(() {
           _listBrands = _subSectionData[0]['brands'];
           final jsonList = _listBrands.map((item) => jsonEncode(item)).toList();
           // using toSet - toList strategy
           final uniqueJsonList = jsonList.toSet().toList();

           // convert each item back to the original form using JSON decoding
           _listBrands = uniqueJsonList.map((item) => jsonDecode(item)).toList();
         });
        }
      });
    });
    _loading = false;
  }

  _getMaxPrice() {
    maxPrice(subSectionId: widget.subSectionId).then((value) {
      print('value:' + value['responseData']['max_price'].toString());
      setState(() {
        _maxPrice = value['responseData']['max_price'].toString();
        // _loading = false;
      });
    });
  }

  _buildMap(id, name, value, {unitID}) {
    // print(id);
    print(unitID);
    // print(unitID != null);
    int trendIndex = myAdAttributesArray.indexWhere((f) => f['id'] == id);
    // print(trendIndex);
    // print(id);
    if (trendIndex == -1) {
      Map<dynamic, dynamic> mapData = unitID != null
          ? {"id": id, "name": name, "value": value, "unit_id": unitID}
          : {"id": id, "name": name, "value": value};
      myAdAttributesArray.add(mapData);
    } else {
      myAdAttributesArray[trendIndex]["value"] = value;
      if (unitID != null) myAdAttributesArray[trendIndex]["unit_id"] = unitID;
    }
    print(myAdAttributesArray);
  }

  @override
  void initState() {
    _getMaxPrice();
    _getSections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(bgColor: AppColors.whiteColor, centerTitle: true),
      body: Stack(
        children: [
          // buildBg(),
          _loading
              ? buildLoading(color: AppColors.redColor)
              : Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Directionality(
            textDirection: AppController.textDirection,
            child: SingleChildScrollView(
            child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildPath(),
                      if (_subSectionData[0]['has_price'] == true)
                        _buildPrice(),
                      if (_listAttributes != null)
                        Container(
                          child: ListView.separated(
                            separatorBuilder: (_, index) => Divider(
                              color: AppColors.grey,
                            ),
                            itemCount: _listAttributes.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, mainIndex) {
                              _options =
                              _listAttributes[mainIndex]['options'];
                              _type = _listAttributes[mainIndex]['config']['searchType'];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _listAttributes[mainIndex]['label']
                                        [_lang],
                                        style: appStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackColor2),
                                      ),
                                      Container(
                                        child: GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _type == 'range'?1:2,childAspectRatio:_type == 'range'? 5 : 2.6,),
                                          // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: _type == 'range'?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width/2,mainAxisExtent: 80,crossAxisSpacing: 10,childAspectRatio: 50),
                                          itemCount:
                                              _type == 'range'
                                              ? 1
                                              : _options.length,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, opIndex) {
                                            return Card(
                                              elevation: 1,
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  // if (_type == 'radio')
                                                  //   _buildRadio(
                                                  //       mainIndex, opIndex),
                                                  if (_type!='range')
                                                    _buildCheckbox(
                                                        mainIndex, opIndex),
                                                  // if (_type == 'select')
                                                  //   _buildSelect(
                                                  //       opIndex, mainIndex),
                                                  // if (_type ==
                                                  //     'multiple_select')
                                                  //   buildMultiSelected(
                                                  //       mainIndex),
                                                  if (_type == 'range')
                                                    _buildRange(
                                                        opIndex, mainIndex),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (_subSectionData[0]['has_brand'])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "النوع",
                                style: appStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Container(
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
                                            value: _brandId,
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
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            onChanged: (String value) {
                                              setState(() {
                                                _subBrandId = null;
                                                _brandId = value;
                                                _listSubBrands = _listBrands
                                                    .where((element) =>
                                                element['id']
                                                    .toString() ==
                                                    value.toString())
                                                    .toList();
                                                _listSubBrands =
                                                _listSubBrands[0]
                                                ['sub_brands'];
                                                if (_listSubBrands != [] &&
                                                    _listSubBrands !=
                                                        null &&
                                                    _listSubBrands
                                                        .isNotEmpty) {
                                                  setState(() {
                                                    hasSubBrands = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    hasSubBrands = false;
                                                  });
                                                }
                                                // print(" typeee ${hasSubBrands}");
                                              });
                                            },
                                            items: _listBrands
                                                .map((listBrand) {
                                              // print("LIST BRAND ${listBrand['id']}");
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                  listBrand['label']
                                                  [_lang],
                                                  style: appStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 16),
                                                ),
                                                value: listBrand['id']
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
                              ),
                              if (hasSubBrands == true)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(4)),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child:
                                          DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton<String>(
                                                isExpanded: false,
                                                value: _subBrandId,
                                                iconSize: 30,
                                                icon: (null),
                                                style: appStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                ),
                                                hint: Text(
                                                  // _subBrandId!=null?_subBrandId.toString():"choose sub type",
                                                  _listSubBrands[0]['label']
                                                  [_lang],
                                                  style: appStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _subBrandId = value;
                                                    // myAdAttributes[_listSubBrands[index]['name']] = value;
                                                    // test(_listSubBrands[index]['id'], value);

                                                    // print(" typeee ${value}");
                                                  });
                                                },
                                                items: _listSubBrands.map(
                                                        (listSubBrand) {
                                                      // print("LIST BRAND ${listSubBrand['id']}");
                                                      return new DropdownMenuItem(
                                                        child: new Text(
                                                          listSubBrand[
                                                          'label']
                                                          [_lang],
                                                          style: appStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16),
                                                        ),
                                                        value: listSubBrand[
                                                        'id']
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
            ),
          ),
         ),
              ),
          if(!_loading)
          Align(alignment: Alignment.bottomCenter,child: _buildButton(context),),

        ],
      ),
    );
  }

  Container _buildSelect(int opIndex, int mainIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    if (trendIndex == -1) {
      _buildMap(
          _listAttributes[mainIndex]['id'],
          _listAttributes[mainIndex]['name'],
          _listAttributes[mainIndex]['options'][0]['id']);
      trendIndex = myAdAttributesArray
          .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    }


    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                dropdownColor: Colors.grey.shade200,
                isExpanded: true,
                value: myAdAttributesArray[trendIndex]['value'].toString(),
                iconSize: 30,
                style: appStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  setState(() {
                    _buildMap(_listAttributes[mainIndex]['id'],
                        _listAttributes[mainIndex]['name'], value);
                  });
                },
                items: _listAttributes[mainIndex]['options']
                    .map<DropdownMenuItem<String>>((listOptions) {
                  // print('LIST  :$list');
                  return new DropdownMenuItem(
                    child: new Text("${listOptions['label'][_lang]}"),
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

  Container _buildRange(int opIndex, int mainIndex) {
    // int trendIndex = myAdAttributesArray
    //     .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    // if (trendIndex == -1) {
    //   _buildMap(_listAttributes[mainIndex]['id'],_listAttributes[mainIndex]['name'],
    //       _listAttributes[mainIndex]['options'][0]['id']);
    // }
    var valFrom;
    var valTo;
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: buildTextField(
                label: _strController.fFrom,
                textInputType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    valFrom = val;
                    if (trendIndex != -1) {
                      valTo = myAdAttributesArray[trendIndex]['value']['to'];
                    }
                    _buildMap(
                      _listAttributes[mainIndex]['id'],
                      _listAttributes[mainIndex]['name'],
                      {'from': valFrom, 'to': valTo},
                    );
                  });
                }),
          ),
          Expanded(
            flex: 1,
            child: buildTextField(
                label: _strController.fTo,
                textInputType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    valTo = val;
                    if (trendIndex != -1) {
                      valFrom =
                      myAdAttributesArray[trendIndex]['value']['from'];
                    }
                    _buildMap(
                      _listAttributes[mainIndex]['id'],
                      _listAttributes[mainIndex]['name'],
                      {'from': valFrom, 'to': valTo},
                    );
                  });
                }),
          ),
        ],
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     // DropdownButtonHideUnderline(
      //     //   child: ButtonTheme(
      //     //     alignedDropdown: true,
      //     //     child: DropdownButton<String>(dropdownColor: Colors.grey.shade200,
      //     //       isExpanded: true,
      //     //       value:myAdAttributesArray[trendIndex]['value']
      //     //           .toString(),
      //     //       // value: '1',
      //     //       iconSize: 30,
      //     //       // icon: (null),
      //     //       style: appStyle(
      //     //         color: Colors.black54,
      //     //         fontSize: 16,
      //     //       ),
      //     //       onChanged: (value) {
      //     //         setState(() {
      //     //           print("select:  ${_listAttributes[mainIndex]['id']}");
      //     //           print(value);
      //     //           _buildMap(_listAttributes[mainIndex]['id'],_listAttributes[mainIndex]['name'], value);
      //     //           print("$myAdAttributesArray");
      //     //         });
      //     //       },
      //     //       items: _listAttributes[mainIndex]['options']
      //     //           .map<DropdownMenuItem<String>>((listOptions) {
      //     //         // print('LIST  :$list');
      //     //         return new DropdownMenuItem(
      //     //           child: new Text(
      //     //               val == "" ? "${listOptions['label'][_lang]}" : val),
      //     //           value: listOptions['id'].toString(),
      //     //         );
      //     //       })?.toList() ??
      //     //           [],
      //     //     ),
      //     //   ),
      //     // ),
      //   ],
    );
  }

  CheckboxListTile _buildCheckbox(int mainIndex, opIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);

    if(trendIndex == -1){
      myAdAttributes[_listAttributes[mainIndex]['name']] = [];
    }

    return CheckboxListTile(
        value: myAdAttributes[_listAttributes[mainIndex]['name']]
            .contains(_listAttributes[mainIndex]['options'][opIndex]['id']) ??
            null,
        title: new Text("${_listAttributes[mainIndex]['options'][opIndex]['label'][_lang]}",style: appStyle(fontSize: 14),),
        controlAffinity: ListTileControlAffinity.leading,
        tristate: true,
        onChanged: (bool val) {
          setState(() {
            myAdAttributes[_listAttributes[mainIndex]['name']]
                .contains(_listAttributes[mainIndex]['options'][opIndex]['id'])
                ? myAdAttributes[_listAttributes[mainIndex]['name']]
                .remove(_listAttributes[mainIndex]['options'][opIndex]['id'])
                : myAdAttributes[_listAttributes[mainIndex]['name']]
                .add(_listAttributes[mainIndex]['options'][opIndex]['id']);
            _buildMap(_listAttributes[mainIndex]['id'],
                _listAttributes[mainIndex]['name'],
                myAdAttributes[_listAttributes[mainIndex]['name']]);

          });
        });
  }



  Column _buildPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: buildTxt(
              txt: _strController.fPrice,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              txtColor: AppColors.blackColor2,
              textAlign: TextAlign.start),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: buildTextField(
                textInputType: TextInputType.number,
                label: _strController.fFrom,
                hintTxt: '0',
                controller: _fromController,
              ),
            ),
            Expanded(
              flex: 1,
              child: buildTextField(
                textInputType: TextInputType.number,
                label: _strController.fTo,
                hintTxt: _maxPrice,
                controller: _toController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Container _buildPath() {
  //   return Container(
  //     width: double.infinity,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             padding: EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade200,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: buildTxt(
  //                 fontSize: 18,
  //                 txtColor: AppColors.blackColor2,
  //                 fontWeight: FontWeight.w700,
  //                 txt: "${_sectionData[0]['label'][_lang]}",
  //                 textAlign: TextAlign.center),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             padding: EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade200,
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: buildTxt(
  //                 fontSize: 20,
  //                 txtColor: AppColors.blackColor2,
  //                 fontWeight: FontWeight.w500,
  //                 txt: "${_subSectionData[0]['label'][_lang]}",
  //                 textAlign: TextAlign.center),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
                        txt: "${_sectionData[0]['label'][_lang]}",
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
                        txt: "${_subSectionData[0]['label'][_lang]}",
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

  buildMultiSelected(mainIndex) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: GridView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 5,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 2,
                      mainAxisExtent: 50),
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
      title: Text(item['label'][_lang]),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        setState(() {
          if (trendIndex == -1) {
            if (checked) {
              _buildMap(_listAttributes[mainIndex]['id'],
                  _listAttributes[mainIndex]['name'], [item['id']]);
            }
          } else {
            if (checked) {
              myAdAttributesArray[trendIndex]['value'].add(item['id']);
            } else {
              myAdAttributesArray[trendIndex]['value'].remove(item['id']);
            }
          }
        });
      },
    );
  }

  void _onItemCheckedChange(
      itemValue, bool checked, attributeId, attributeName) {
    setState(() {
      print(attributeId);
      print(checked);
      if (checked) {
        myAdAttributesMulti.add(itemValue);
      } else {
        myAdAttributesMulti.remove(itemValue);
      }

      _buildMap(attributeId, attributeName, myAdAttributesMulti);
    });
  }

  Row _buildRadio(int mainIndex, int opIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<dynamic>(
          focusColor: Colors.white,
          groupValue: _listAttributes[mainIndex]['name'],
          onChanged: (dynamic newValue) {
            setState(() {
              _listAttributes[mainIndex]['name'] = newValue;
              _buildMap(_listAttributes[mainIndex]['id'],
                  _listAttributes[mainIndex]['name'], newValue);
              print("radio:  ${_listAttributes[mainIndex]['id']}");
              // print(_options[index]['label'][_lang]);
              // print(list['name']);
            });
          },
          value: _options[opIndex]['id'],
        ),
        Text(
          _options[opIndex]['label'][_lang],
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        ),
      ],
    );
  }
  Container _buildButton(BuildContext context) {
    // print("AT:$myAdAttributes");
    return Container(
      child: myButton(
        context: context,
        height: 50,
        width: double.infinity,
        btnTxt: "بحث",
        fontSize: 20,
        txtColor: AppColors.whiteColor,
        radius: 2,
        btnColor: AppColors.redColor,
        onPressed: () {
          var urlEncode = [];
          urlEncode.add(
              "sectionId=${Uri.encodeComponent(widget.sectionId.toString())}");
          urlEncode.add(
              "subSectionId=${Uri.encodeComponent(widget.subSectionId.toString())}");
          urlEncode.add(
              "countryId=${Uri.encodeComponent(countryID.toString())}");
          if (_brandId != null)
            urlEncode.add(
                "brand=${Uri.encodeComponent(widget.subSectionId.toString())}");
          if (_subBrandId != null)
            urlEncode
                .add("subBrand=${Uri.encodeComponent(_brandId.toString())}");

          if (_fromController.text.isNotEmpty) {
            urlEncode.add(
                "price[from]=${Uri.encodeComponent(_fromController.text.toString())}");
          }
          if (_toController.text.isNotEmpty) {
            urlEncode.add(
                "price[to]=${Uri.encodeComponent(_toController.text.toString())}");
          }
          for (var item in myAdAttributesArray) {
            var directEncodeTypes = ['String', 'int', 'double', 'float'];

            if (item['value'] == [] || item['value'] == null) continue;
            if (directEncodeTypes
                .contains(item['value'].runtimeType.toString())) {
              urlEncode.add(
                  "${Uri.encodeComponent(item['name'].toString())}=${Uri.encodeComponent(item['value'].toString())}");
            } else {
              var array = item['value'];
              if (item['value'].runtimeType.toString() == 'List<dynamic>') {
                array = item['value'].asMap();
              }
              array.forEach((i, value) {
                var keyName = item['name'] + '[${i}]';
                urlEncode
                    .add("${keyName}=${Uri.encodeComponent(value.toString())}");
              });
            }
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PublicAdsScreen(
                  isPrivate: false,
                  isFav: false,
                  isMain: false,
                  section: widget.sectionId,
                  subSection: widget.subSectionId,
                  isFilter: true,
                  sectionId: widget.sectionId,
                  subSectionId: widget.subSectionId,
                  filteredData: urlEncode.join('&'),
                ),
              ));

          print(urlEncode.join("&"));
          // return(urlEncode.join("&"));
        },
      ),
    );
  }
}

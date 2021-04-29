import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController _fromController = TextEditingController()..text;
  TextEditingController _toController = TextEditingController()..text;
  final _strController = AppController.strings;

  int sectionId = 3;
  int subSectionId = 57;

  List _sectionData;
  List _subSectionData;
  List _listAttributes;
  List _options;
  bool _loading = true;
  String _lang;
  String _maxPrice;
  String _type;
  List<dynamic> myAdAttributesArray = []; //edit
  List<dynamic> myAdAttributesMulti = []; //edit
  Map myAdAttributes = {}; //edit

  _getSections() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();

    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      setState(() {
        _lang = _gp.getString("lang");

        _sectionData = _sectionData
            .where((element) =>
                element['id'] == sectionId &&
                element['sub_sections'][0]['id'] == subSectionId)
            .toList();

        _listAttributes = _sectionData[0]['sub_sections'][0]['attributes'];
        print('');
        // _checkBoxTypeData = _attributes.where((element) =>element['config']['searchType'] == 'checkbox').toList();

        _subSectionData = _sectionData[0]['sub_sections'];
      });
    });
  }

  _getMaxPrice() {
    maxPrice(subSectionId: subSectionId).then((value) {
      print('value:' + value['responseData']['max_price'].toString());
      setState(() {
        _maxPrice = value['responseData']['max_price'].toString();
        _loading = false;
      });
    });
  }

  _buildMap(id, value, {unitID}) {
    // print(id);
    print(unitID);
    // print(unitID != null);
    int trendIndex = myAdAttributesArray.indexWhere((f) => f['id'] == id);
    // print(trendIndex);
    // print(id);
    if (trendIndex == -1) {
      Map<dynamic, dynamic> mapData = unitID != null
          ? {"id": id, "value": value, "unit_id": unitID}
          : {"id": id, "value": value};
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
    return Directionality(
      textDirection: AppController.textDirection,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(bgColor: AppColors.whiteColor, centerTitle: true),
        body: Stack(
          children: [
            // buildBg(),
            _loading
                ? buildLoading(color: AppColors.redColor)
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildPath(),
                        if (_subSectionData[0]['has_price'] == true)
                          _buildPrice(),
                        Container(
                          child: ListView.separated(
                            separatorBuilder: (_, index) => Divider(
                              color: AppColors.grey,
                             ),
                            itemCount: _listAttributes.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, mainIndex) {
                              List<dynamic> selectedValues = [];
                              String selectedValues2 = "";
                              if (_type != 'checkbox' ||
                                  _type != 'radio') if (myAdAttributes[
                                          _listAttributes[mainIndex]["name"]]
                                      ?.isEmpty ??
                                  true)
                                myAdAttributes[_listAttributes[mainIndex]
                                    ["name"]] = selectedValues2;
                              if (_type == 'checkbox' ||
                                  _type == 'radio') if (myAdAttributes[
                                          _listAttributes[mainIndex]["name"]]
                                      ?.isEmpty ??
                                  true)
                                myAdAttributes[_listAttributes[mainIndex]
                                    ["name"]] = selectedValues;
                              _options = _listAttributes[mainIndex]['options'];
                              _type = _listAttributes[mainIndex]['config']
                                  ['searchType'];
                              print('Type: $_type     ${_listAttributes[mainIndex]['name']} ');
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                       Text(
                                          _listAttributes[mainIndex]['label']['ar'],
                                          style: appStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.blackColor2),
                                       ),
                                      Container(
                                        child: ListView.builder(
                                          itemCount: _type == 'select' || _type == 'multiple_select'
                                              ? 1
                                              :_options.length,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, opIndex) {
                                            return Card(
                                              elevation: 1,
                                              color: Colors.white ,
                                              child: Column(
                                                children: [
                                                  if (_type == 'radio') _buildRadio(mainIndex, opIndex),
                                                  if (_type == 'checkbox')
                                                    _buildCheckbox(
                                                        mainIndex, opIndex),
                                                  if (_type == 'select')
                                                    _buildSelect(opIndex, mainIndex),
                                                  if (_type == 'multiple_select') buildMultiSelected(mainIndex),
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
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Container _buildSelect(int opIndex, int mainIndex) {
    int trendIndex = myAdAttributesArray
        .indexWhere((f) => f['id'] == _listAttributes[mainIndex]['id']);
    if(trendIndex == -1){
      _buildMap(_listAttributes[mainIndex]['id'], _listAttributes[mainIndex]['options'][0]['id']);
    }

    var val = "";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(dropdownColor: Colors.grey.shade200,
                isExpanded: true,
                value:myAdAttributesArray[trendIndex]['value']
                    .toString(),
                // value: '1',
                iconSize: 30,
                // icon: (null),
                style: appStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  setState(() {
                    print("select:  ${_listAttributes[mainIndex]['id']}");
                    print(value);
                    _buildMap(_listAttributes[mainIndex]['id'], value);
                    print("$myAdAttributesArray");
                  });
                },
                items: _listAttributes[mainIndex]['options']
                    .map<DropdownMenuItem<String>>((listOptions) {
                  // print('LIST  :$list');
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

  CheckboxListTile _buildCheckbox(int mainIndex, opIndex) {
    return CheckboxListTile(
        // value: null,
        value: myAdAttributes[_listAttributes[mainIndex]['name']]
                .contains(_options[opIndex]['id'].toString()) ??
            null,
        title: new Text("${_options[opIndex]['label'][_lang]}"),
        controlAffinity: ListTileControlAffinity.leading,
        tristate: true,
        onChanged: (bool val) {
          setState(() {
            myAdAttributes[_listAttributes[mainIndex]['name']]
                    .contains(_options[opIndex]['id'])
                ? myAdAttributes[_listAttributes[mainIndex]['name']]
                    .remove(_options[opIndex]['id'])
                : myAdAttributes[_listAttributes[mainIndex]['name']]
                    .add(_options[opIndex]['id']);
            _buildMap(_listAttributes[mainIndex]['id'],
                myAdAttributes[_listAttributes[mainIndex]['name']]);
            print(myAdAttributesArray);
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
                label: _strController.fFrom,
                hintTxt: '0',
                controller: _fromController,
              ),
            ),
            Expanded(
              flex: 1,
              child: buildTextField(
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

  Container _buildPath() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: buildTxt(
                  fontSize: 20,
                  txtColor: AppColors.blackColor2,
                  fontWeight: FontWeight.w700,
                  txt: "${_sectionData[0]['label'][_lang]}",
                  textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: buildTxt(
                  fontSize: 20,
                  txtColor: AppColors.blackColor2,
                  fontWeight: FontWeight.w500,
                  txt: "${_sectionData[0]['sub_sections'][0]['label'][_lang]}",
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  buildMultiSelected(mainIndex) {
    return SingleChildScrollView(
      child:
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              child: ListView(
                // physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: _options.map((item)=>_buildItem(item,mainIndex)).toList(),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Text('down')
          ),
        ],
      ),

    );
  }
  Widget _buildItem(item,mainIndex) {
    final checked = myAdAttributesMulti.contains(item['id']);
    return CheckboxListTile(
      value: checked,
      title: Text(item['label'][_lang]),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        _onItemCheckedChange(item['id'], checked,_listAttributes[mainIndex]['id']);

      },
    );
  }
  void _onItemCheckedChange(itemValue, bool checked,attributeId) {
    setState(() {
      print(attributeId);
      print(  checked);
      if (checked) {
        myAdAttributesMulti.add(itemValue);
      } else {
        myAdAttributesMulti.remove(itemValue);
      }

      _buildMap(attributeId,myAdAttributesMulti);

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
            _buildMap(_listAttributes[mainIndex]["id"], newValue);
            setState(() {
              _listAttributes[mainIndex]['name'] = newValue;
              _buildMap(_listAttributes[mainIndex]['id'], newValue);
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
}

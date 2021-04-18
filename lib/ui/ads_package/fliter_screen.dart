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

  int sectionId = 26;
  int subSectionId = 201;

  List _sectionData;
  List _subSectionData;
  List _attributes;
  List _checkBoxTypeData;
  bool _loading = true;
  String _lang;
  String _maxPrice;

  _getSections() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();

    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      setState(() {
        _lang = _gp.getString("lang");

        _sectionData = _sectionData.where((element) =>element['id'] == sectionId &&element['sub_sections'][0]['id'] == subSectionId).toList();

        _attributes = _sectionData[0]['sub_sections'][0]['attributes'];

        _checkBoxTypeData = _attributes.where((element) =>element['config']['searchType'] == 'checkbox').toList();

        _subSectionData = _sectionData[0]['sub_sections'];
      });
     });
    print(_checkBoxTypeData.length);
  }
  _getMaxPrice() {
    maxPrice(subSectionId: subSectionId).then((value) {
      print('value:'+value['responseData']['max_price'].toString());
      setState(() {
        _maxPrice = value['responseData']['max_price'].toString();
        _loading = false;
      });
    });
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
            buildBg(),
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
                              thickness: 1,
                            ),
                            itemCount: _attributes.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              // List _radioData =
                              return Column(
                                  children: [
                                    _buildCheckBox(),
                                  ],
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

  _buildCheckBox(){
   return ListView.builder(
       physics: ClampingScrollPhysics(),
       shrinkWrap: true,itemCount: _checkBoxTypeData.length,itemBuilder: (ctx,index){
         var _options = _checkBoxTypeData[index]['options'];
         print('OPTIONS:'+_options);
          var _negotiable = false;
     return Container(
       child: ListView.builder(itemBuilder: (context, index){
         return null;
       },),
     );

     //  CheckboxListTile(
     //     value: _checkBoxTypeData[0][index],
     //     title: new Text('item $index'),
     //     controlAffinity: ListTileControlAffinity.leading,
     //     onChanged:(bool val){itemChange(val, index);}
     // );
   });
  }
  void itemChange(bool val,int index){
    setState(() {
      _attributes[index] = val;
    });
  }
}

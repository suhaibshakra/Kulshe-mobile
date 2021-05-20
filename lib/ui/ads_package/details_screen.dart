import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/play_video.dart';
import 'package:kulshe/ui/ads_package/time_ago.dart';
import 'package:kulshe/ui/profile/advertiser_profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'ad_details_screen.dart';

class DetailsScreen extends StatefulWidget {
  final int adID;
  final int countryId;
  final String slug;
  final bool isPrivate;

  const DetailsScreen({Key key, @required this.adID, @required this.slug, this.countryId, this.isPrivate})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _strController = AppController.strings;
  TextEditingController _otherReason = new TextEditingController();
  TextEditingController _bodyController = TextEditingController()..text;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int abuseID;
  String abuseReason;
  bool _showOtherReason = false;
  bool _loading = true;
  bool _loadFavIcon = false;
  List _data;
  List _adBrands;
  List _adSubBrands;
  List _sectionData;
  List _subSectionData;
  int _selection = 0;
  int _brandId = 0;
  int _subBrandId = 0;
  List _listImg = [];
  List<Widget> imageSliders;
  var _details;
  var _attributes;
  var abuseReasons;
  List _countryData;
  List _citiesData;
  String _country;
  String _city;
  String _sectionText;
  String _subSectionText;


  _getSections({int sec, int subSec, int br, int subBr}) async {
    SharedPreferences _gp = await SharedPreferences.getInstance();

    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      // print('SUBSEC : $subSec');
      _sectionData = sections[0]['responseData'];
      // log("AAA : ${_sectionData[0]}");
      _sectionData =
          _sectionData.where((element) => element['id'] == sec).toList();
      _sectionText = _sectionData[0]['label']['ar'];
      // _subSectionData = _sectionData.where((element) => element['sub_sections']['id'] == sec).toList();
      _subSectionData = _sectionData[0]['sub_sections']
          .where((element) => (element['id'] == subSec))
          .toList();
      _subSectionText = _subSectionData[0]['label']['ar'];

      _adBrands = _subSectionData[0]['brands']
          .where((element) => (element['id'] == _brandId))
          .toList();
      _adSubBrands = _adBrands[0]['sub_brands']
          .where((element) => (element['id'] == _subBrandId))
          .toList();
      // _adSubBrands = _adBrands[0]['sub_brands'];
    });
  }

  launchWhatsApp(String mobile) async {
    final link = WhatsAppUnilink(
      phoneNumber: mobile,
      text: "",
    );
    await launch('$link');
  }

  shareData(BuildContext context) {
    Share.share(
      'Some text here',
      subject: 'Update the coordinate!',
    );
  }

  _getCountries(countryId, cityId) async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    print('countryId:$countryId');
    print('countryId:$cityId');
    _countryData = countries[0]['responseData'];
    setState(() {
      _countryData =
          _countryData.where((element) => element['id'] == countryId).toList();
      _country = _countryData[0]['label']['ar'];
      _citiesData = _countryData[0]['cities']
          .where((element) => element['id'] == cityId)
          .toList();
      _city = _citiesData[0]['label']['ar'];
      print('AAAAAAAAAAAAA$_city');
    });
    // // print('_${_countryData.where((element) => element.classified == true)}');
    // // print(sections[0].responseData[4].name);
  }
  var _statusCode = -1;

  @override
  void initState() {
    _selection = 1;
    print(widget.adID);
    print(widget.slug);
    AdDetailsServicesNew.getAdData(adId: widget.adID, slug: widget.slug,countryId: widget.countryId)
        .then((value) {
      setState(() {
        // customeCode = value[0]['custom_code'];
        print("statusCode: $value");

        if(value!= 410) {
          _data = value;
          // print('DATA: ${value}');
          _getCountries(_data[0]['responseData']['country_id'],
              _data[0]['responseData']['city_id']);
          if (_data[0]['responseData']['images'] != null)
            for (var links in _data[0]['responseData']['images']) {
              _listImg.add(links['medium']);
            }
          if (_listImg != null || _listImg != [])
            imageSliders = _listImg
                .map(
                  (item) =>
                  Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                                item, fit: BoxFit.cover, width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child: Text(
                                  '${_listImg.indexOf(item) + 1} / ${_listImg
                                      .length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            )
                .toList();
          _brandId = _data[0]['responseData']['brand_id'];
          _subBrandId = _data[0]['responseData']['sub_brand_id'];
          _details = _data[0]['responseData'];
          log("DETAILS:${_details[1]}");
          _attributes = _data[0]['responseData']['selected_attributes'];
          abuseReasons = _details['abuse_reasons'];
          // log('_sliderImages: $_sliderImages');
          _getSections(
            sec: _data[0]['responseData']['section_id'],
            subSec: _data[0]['responseData']['sub_section_id'],
            br: _data[0]['responseData']['brand_id'],
            subBr: _data[0]['responseData']['sub_brand_id'],
          );
          _loading = false;
        }else{
          setState(() {
            _statusCode = value;
            print('Status: $_statusCode');
            _loading = false;
          });

        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(centerTitle: true, bgColor: AppColors.whiteColor),
      body: _loading
          ? buildLoading(color: AppColors.redColor):_statusCode == 410
      ? Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.red,
                    offset: Offset(2, 2),
                    blurRadius: 1,
                    spreadRadius: 2)
              ]),
          child: buildIconWithTxt(
            label: Text(
              "هذا الإعلان محذوف",
              style: appStyle(
                  color: AppColors.whiteColor, fontSize: 22),
            ),
            iconColor: AppColors.whiteColor,
            iconData: Icons.arrow_back_outlined,
            size: 30,
            action: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    )
          : Directionality(
              textDirection: AppController.textDirection,
              child: SingleChildScrollView(
                child: ListView.builder(shrinkWrap: true,itemCount: _data.length,physics: ClampingScrollPhysics(),itemBuilder: (context, index) {
                  var _attributes = _data[0]['responseData']
                  ['selected_attributes'];
                  print('_details:${_details['user_contact']}');
                    var abuseReasons = _details['abuse_reasons'];
                    String status = _data[0]['responseData']['status'];
                    bool isPaused = _data[0]['responseData']['paused'];
                  // print('status:$status');
                        return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  _details['title'].toString(),
                                  style: appStyle(
                                    fontSize: 16,
                                    color: AppColors.blackColor2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: buildIcons(
                                  height: 50,width: 50,
                                    hasShadow: true,
                                    bgColor: AppColors.whiteColor,
                                    iconData: _details['is_favorite_ad'] == false
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                    action: () {
                                      favoriteAd(
                                        scaffoldKey: _scaffoldKey,
                                        context: context,
                                        adId: _details['id'],
                                        state: _details['is_favorite_ad'] == true
                                            ? "delete"
                                            : "add",
                                      ).then((value) {
                                        setState(() {
                                          AdDetailsServicesNew.getAdData(
                                              adId: widget.adID,
                                              slug: widget.slug,
                                          )
                                              .then((value) {
                                           setState(() {
                                             _details['is_favorite_ad'] = !_details['is_favorite_ad'];
                                           });
                                          });
                                        });
                                      });
                                    }),
                              )
                            )
                          ],
                        ),
                      ),
                      if (!_details['is_free'])
                        Container(
                          color: AppColors.green.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: _details['has_price'] &&
                                            _details['price'] != 0 &&
                                            _details['currency'] != null
                                            ? Text(
                                          '${_details['price'].toString() +"  "+ _details['currency']['ar'].toString()}',
                                          style: appStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )
                                            : Text(
                                          _strController.callAdvPrice,
                                          style: appStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      if(widget.isPrivate && isPaused)
                                        Container(
                                          width: double.infinity,
                                          color: AppColors.amberColor,
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 4),child: buildTxt(txt: "هذا العلان متوقف !",fontSize: 20,txtColor: AppColors.whiteColor),),
                                        ),
                                      if(status == 'expired')
                                        Container(
                                          width: double.infinity,
                                          color: AppColors.amberColor,
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: buildTxt(txt: "هذا العلان منتهي الصلاحية !",fontSize: 20,txtColor: AppColors.whiteColor),
                                        )
                                    ],
                                  ),
                                ),
                                if (_details['negotiable'])
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '( قابل للتفاوض )',
                                      style: appStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (_details['is_free'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              _strController.free,
                              style: appStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greenColor),
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (imageSliders.isNotEmpty && imageSliders.length>1)
                        Container(
                          height: mq.size.height * 0.255,
                          child: Center(
                            child: EnlargeStrategyDemo(
                              imageSliders: imageSliders,
                            ),
                          ),
                        ),
                      if (imageSliders.isNotEmpty && imageSliders.length == 1)
                        Container(
                          height: mq.size.height * 0.255,
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${_data[0]['responseData']['images'][0]['medium']}"),fit: BoxFit.cover),),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if('${_details['user_contact']}' != '[]')
                            Expanded(
                              flex: 6,
                              child: InkWell(
                                onTap: (){
                                  print('${_details['user_contact']['hash_id']}');
                                  return Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertiserProfile(_details['user_contact']['hash_id']),));
                                },
                                child: Row(
                                  children: [
                                    _details['user_contact']['user_image'] != null
                                        ?CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            _details['user_contact']
                                            ['user_image']),
                                    )
                                        :
                                     CircleAvatar(
                                        radius: 22,
                                        backgroundImage: AssetImage(
                                            'assets/images/no_img.png'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                      Text(
                                        _details['user_contact']['nick_name'],
                                        style: appStyle(
                                            color: AppColors.blackColor2,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (_details['show_contact']==true &&
                                _details['user_contact'] != null && (!widget.isPrivate && !isPaused && (status == 'approved' || status == 'new')))
                                ? Expanded(
                                flex: (_details['user_contact']['mobile_number'] != null)?5:1,
                                child: Row(
                                  children: [
                                    if(_details['user_contact']['mobile_number'] != null)
                                    buildIcons(
                                      width: 35,
                                      height: 35,
                                      size: 15,
                                      iconData: FontAwesomeIcons.whatsapp,
                                      color: AppColors.whiteColor,
                                      bgColor: AppColors.green,
                                      action: () => launchWhatsApp(
                                          _details['user_contact']
                                          ['mobile_number']
                                              .toString()),
                                      // _launchURLWhatsApp(_details['user_contact']['mobile_number'].toString());
                                    ),
                                    if(_details['user_contact']['mobile_number'] != null)
                                    buildIcons(
                                        width: 35,
                                        height: 35,
                                        size: 15,
                                        iconData: FontAwesomeIcons.phoneAlt,
                                        bgColor: AppColors.blue,
                                        color: AppColors.whiteColor,
                                        action: () {
                                          // _launchCaller(_details['user_contact']['mobile_number'].toString());
                                          launch(
                                              "tel://${_details['user_contact']['mobile_number'].toString()}");
                                        }),
                                    buildIcons(
                                      width: 35,
                                      height: 35,
                                      size: 15,
                                      iconData: FontAwesomeIcons.envelope,
                                      color: AppColors.whiteColor,
                                      bgColor: AppColors.redColor,
                                      action: () {
                                        _buildMessage(context: context);
                                        // launch(
                                        //     'mailto:${_details['user_contact']['email'].toString()}');
                                        // _launchURLEmail(
                                        //   _details['user_contact']
                                        //           ['mobile_number']
                                        //       .toString(),
                                        // );
                                      },
                                    ),
                                  ],
                                ))
                                : Expanded(
                              flex: 1,
                              child: Center(),
                            ),
                            if(!isPaused && (status == 'approved' || status == 'new'))
                            buildIcons(
                                width: 35,
                                height: 35,
                                size: 15,
                                iconData: FontAwesomeIcons.shareAlt,
                                bgColor: AppColors.greyFour,
                                color: AppColors.whiteColor,
                                action: ()=>shareData(context)),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    width: 1, color: AppColors.greyThree),
                                borderRadius: BorderRadius.circular(0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: buildIconWithTxt(
                                    label: Text(
                                      "$_subSectionText",
                                      style: appStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.descColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    iconData: FontAwesomeIcons.windows,
                                    size: 18,
                                  ),
                                  // child: Text("$_sectionText",style: appStyle(fontSize: 15,fontWeight: FontWeight.w400),)
                                ),
                                SizedBox(
                                  height: 25,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: AppColors.greyThree,
                                  ),
                                ),
                                Center(
                                  child: buildIconWithTxt(
                                    label: Text(
                                      "${TimeAgo.timeAgoSinceDate(_details['created_at'])}",
                                      style: appStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.descColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    iconData: FontAwesomeIcons.clock,
                                    size: 18,
                                  ),
                                  // child: Text("$_sectionText",style: appStyle(fontSize: 15,fontWeight: FontWeight.w400),)
                                ),
                                SizedBox(
                                  height: 25,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: AppColors.greyThree,
                                  ),
                                ),
                                Center(
                                  child: buildIconWithTxt(
                                    label: Text(
                                      "$_country - $_city",
                                      style: appStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.descColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    iconData: Icons.location_on,
                                    size: 18,
                                  ),
                                  // child: Text("$_sectionText",style: appStyle(fontSize: 15,fontWeight: FontWeight.w400),)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if(widget.isPrivate)
                        if (_adBrands.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "النوع".toString(),
                                        style: appStyle(
                                            fontSize: 18,
                                            color: AppColors.blackColor2 ,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        _adBrands[0]['label']['ar'].toString(),
                                        style: appStyle(
                                            fontSize: 16,
                                            color: AppColors.blackColor2.withOpacity(0.8),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.greyThree,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      if (_adBrands.isNotEmpty)
                        if (_adSubBrands.isNotEmpty)
                          Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "الفرع".toString(),
                                        style: appStyle(
                                            fontSize: 18,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        _adSubBrands[0]['label']['ar'].toString(),
                                        style: appStyle(
                                            fontSize: 18,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.greyThree,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                      if (_attributes.length != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _attributes.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  var _myAttributes = _attributes[position];
                                  var _selectedValue =
                                  _myAttributes['selected_value'];
                                  var attributeName = (_selectedValue
                                      .runtimeType ==
                                      int ||
                                      _selectedValue.runtimeType == String ||
                                      _selectedValue.runtimeType == double)
                                      ? _selectedValue.toString()
                                      : _selectedValue.runtimeType.toString() ==
                                      "_InternalLinkedHashMap<String, dynamic>"
                                      ? _selectedValue['name']['ar']
                                      .toString()
                                      : _selectedValue;
                                  var _myLabel = _attributes[position]['label'];

                                  // print('a type: ${attributeName.toString()}');
                                  return Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              _myLabel['ar'].toString(),
                                              style: appStyle(
                                                fontSize: 17,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                        if (_selectedValue.runtimeType
                                            .toString() !=
                                            "List<dynamic>")
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  attributeName.toString(),
                                                  style: appStyle(
                                                      fontSize: 15,
                                                      color: AppColors.greyFour,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                if (_attributes[position]
                                                ['has_unit'] ==
                                                    1)
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(_attributes[position][//TODO : UNIT
                                                      'selected_unit_name']['ar'] .toString(),style: appStyle(
                                                          fontSize: 15,
                                                          color: AppColors.greyFour,
                                                          fontWeight:
                                                          FontWeight.w700),),
                                                    ],
                                                  )
                                              ],
                                            ),
                                          ),
                                        if (_selectedValue.runtimeType
                                            .toString() ==
                                            "List<dynamic>")
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 0),
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                  ClampingScrollPhysics(),
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 3),
                                                  itemCount: attributeName.length,
                                                  itemBuilder: (ctx, index) {
                                                    return Center(
                                                        child: Text(
                                                          attributeName[index]['name']
                                                          ['ar']
                                                              .toString() +
                                                              " , ",
                                                          style: appStyle(
                                                              fontSize: 15,
                                                              color: AppColors.greyFour,
                                                              fontWeight:
                                                              FontWeight.w700),
                                                        ));
                                                  }),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    thickness: 1,
                                  );
                                },
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.greyThree,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(_details['show_contact'] == true)
                                if (_details['user_contact']['user_phone'] != null)
                              Expanded(
                                flex: 1,
                                child: myButton(
                                    btnTxt: _strController.callAdv,
                                    fontSize: 16,
                                    btnColor: Colors.lightBlueAccent,
                                    radius: 8,
                                    context: context,
                                    txtColor: AppColors.whiteColor,
                                    height: 35,
                                    onPressed: () {
                                      launch(
                                          "tel://${_details['user_contact']['mobile_number'].toString()}");
                                      // print('${_details['video']}');
                                      //   if(_details['video'] != null)
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideo(videoUrl: _details['video'],),),);
                                    }),
                              ),
                              if (_details['show_contact']==true &&
                                  _details['user_contact']['email'] != null )
                              SizedBox(
                                width: 10,
                              ),
                              if(!widget.isPrivate && !isPaused && (status == 'approved' || status == 'new'))
                                Expanded(
                                flex: 1,
                                child: myButton(
                                    btnTxt: _strController.sendEmail,
                                    fontSize: 16,
                                    btnColor: Colors.lightBlueAccent,
                                    radius: 8,
                                    context: context,
                                    txtColor: AppColors.whiteColor,
                                    height: 35,
                                    onPressed: () =>
                                        _buildMessage(context: context)
                                  // launch(
                                  // 'mailto:${_details['user_contact']['email'].toString()}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if(!isPaused && (status == 'approved' || status == 'new' || status == 'edited'))
                        Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            print('REASON: ${abuseReasons.runtimeType}');
                            _buildAbuseDialog(
                                context: context, details: abuseReasons);
                          },
                          child: buildTxt(
                              txt: "بلغ عن إساءة",
                              fontSize: 18,
                              txtColor: AppColors.blue,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            children: [
                              if(widget.isPrivate && !isPaused && (status == 'approved' || status == 'new'))
                                Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Divider(
                                      thickness: 1,
                                      color: AppColors.greyThree,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Text(
                                    _strController.adDetails,
                                    style: appStyle(
                                        color: AppColors.blackColor2,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Html(
                                  customTextAlign: (_) => TextAlign.start,
                                  data: _details['body'],
                                  defaultTextStyle: appStyle(
                                      color:
                                      AppColors.blackColor2.withOpacity(0.8),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.greyThree,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(_details['video']!= null)
                                myButton(
                                    btnTxt: 'عرض الفيديو',
                                    fontSize: 16,
                                    btnColor: Colors.black26,
                                    radius: 8,
                                    context: context,
                                    txtColor: AppColors.whiteColor,
                                    height: 35,
                                    onPressed: () {
                                      print('${_details['video']}');
                                      if (_details['video'] != null)
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlayVideoScreen(
                                                  videoUrl: _details['video'],
                                                ),
                                          ),
                                        );
                                    }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Column(
                          children: [
                            Container(
                              child: buildIconWithTxt(
                                iconData: FontAwesomeIcons.exclamationTriangle,
                                iconColor: Colors.amber,
                                size: 20,
                                label: Text(
                                  _strController.warning,
                                  style: appStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor2),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "لا ترسل أي معلومات شخصية أو صور أو أي أموال من خلال الإنترنت و قم بالازم للتأكد من صحة الإعلان و الجهة المعلنة. و توخى الحذر من الإعلانات التي تروج الربح السريع و تزوير الوثائق.",
                              style: appStyle(
                                  color: AppColors.blackColor2.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },),
              ),
            ),
    );
  }

  _buildAbuseDialog(
      {BuildContext context, List<dynamic> details, Function action}) {
    return Alert(
      context: context,
      title: "بلغ عن إساءة",
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.45,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: details.length,
          itemBuilder: (ctx, index) {
            return
                // Row(
                // children: <Widget>[
                Column(
              children: [
                RadioListTile(
                  value: details[index]['id'],
                  groupValue: _selection,
                  title: Text(
                    details[index]['reason'],
                    style: TextStyle(color: Colors.black54),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selection = val;
                      abuseID = val;
                      abuseReason = details[index]['reason'];
                      if (details[index]['id'] == 5) {
                        setState(() {
                          _showOtherReason = true;
                        });
                      } else {
                        setState(() {
                          _showOtherReason = false;
                        });
                      }
                    });
                  },
                  selected: true,
                ),
                if (details[index]['id'] == 5 && _showOtherReason == true)
                  buildTextField(
                    label: "reason",
                    textInputType: TextInputType.text,
                    controller: _otherReason,
                    hintTxt: "Enter reason",
                    fromPhone: false,
                  )
              ],
            );
            // Radio(
            //   activeColor: Colors.red,
            //   focusColor: Colors.white,
            //   groupValue: _selection,
            //   onChanged: (newVal) {
            //     setSelectedRadio(newVal);
            //   },
            //   value: _selection,
            // ),
            // Text(
            //   details[index]['reason'],
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),
            // ),
            // ],
            // );
          },
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "إرسال",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            print(widget.adID);
            print(abuseID);
            print(abuseReason);
            abuseAd(
                context: context,
                adId: widget.adID,
                abuseId: abuseID,
                abuseDescription: _otherReason.text.isNotEmpty
                    ? _otherReason.text.toString()
                    : null).then((value){
                      value == "done"?Navigator.of(context, rootNavigator: true).pop():null;
            });
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  _buildMessage({BuildContext context}) {
    return Alert(
      context: context,
      title: " أرسل رسالة عبر البريد الكتروني",
      content: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView(
            shrinkWrap: true,
            children: [
              SingleChildScrollView(
                child: Container(
                  child: buildTextField(
                    validator: (value) => (_bodyController.text == null ||
                            _bodyController.text.isEmpty)
                        ? "يرجى إدخال النص"
                        : null,
                    label: "نص الرسالة",
                    controller: _bodyController,
                    minLines: 4,
                    textInputType: TextInputType.multiline,
                  ),
                ),
              ),
            ],
          )),
      buttons: [
        DialogButton(
          child: Text(
            _strController.cancel,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: AppColors.redColor,
        ),
        DialogButton(
          child: Text(
            "إرسال",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            sendMessage(
                context: context,
                adId: widget.adID,
             txtBody: _bodyController.text.toString(),).then((value){
              Navigator.of(context, rootNavigator: true).pop();
              _bodyController.clear();
            });
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  setSelectedRadio(int val) {
    setState(() {
      _selection = val;
    });
  }
}
class EnlargeStrategyDemo extends StatelessWidget {
  final List imageSliders;

  EnlargeStrategyDemo({Key key, this.imageSliders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            items: imageSliders.toList(),
          ),
        ],
      ),
    );
  }
}
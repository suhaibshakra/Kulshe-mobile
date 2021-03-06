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

class DetailsScreen extends StatefulWidget {
  final int adID;
  final int countryId;
  final String slug;
  final bool isPrivate;

  const DetailsScreen(
      {Key key,
      @required this.adID,
      @required this.slug,
      this.countryId,
      this.isPrivate})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _strController = AppController.strings;
  TextEditingController _otherReason = new TextEditingController();
  TextEditingController _bodyController = TextEditingController()..text;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeyAbuse = GlobalKey<FormState>();
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
  int _relatedLength = 0;
  bool _loadMore = false;
  bool reported = false;

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

      if (_subSectionData[0]['brands'].toString().isNotEmpty) {
        _adBrands = _subSectionData[0]['brands']
            .where((element) => (element['id'] == _brandId))
            .toList();
        _adSubBrands = _adBrands[0]['sub_brands']
            .where((element) => (element['id'] == _subBrandId))
            .toList();
      }
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

  var _statusCode = 1;
  var _relatedAds;

  @override
  void initState() {
    _selection = 1;
    print(widget.adID);
    print(widget.slug);
    AdDetailsServicesNew.getAdData(
            adId: widget.adID, slug: widget.slug, countryId: widget.countryId)
        .then((value) {
      setState(() {
        // customeCode = value[0]['custom_code'];
        print("statusCode: $value");

        if (value != 410) {
          _data = value;
          print('DATA: ${value}');
          _getCountries(_data[0]['responseData']['country_id'],
              _data[0]['responseData']['city_id']);
          if (_data[0]['responseData']['images'] != null)
            for (var links in _data[0]['responseData']['images']) {
              _listImg.add(links['medium']);
            }
          if (_listImg != null || _listImg != [])
            imageSliders = _listImg
                .map(
                  (item) => Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(item,
                                fit: BoxFit.cover, width: 1000.0),
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
                                  '${_listImg.indexOf(item) + 1} / ${_listImg.length}',
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
          _relatedAds = _details['related_ads'];
          if (_relatedAds.length < 6) {
            _relatedLength = _relatedAds.length;
          } else {
            _relatedLength = 6;
          }
          // log('_sliderImages: $_sliderImages');
          _getSections(
            sec: _data[0]['responseData']['section_id'],
            subSec: _data[0]['responseData']['sub_section_id'],
            br: _data[0]['responseData']['brand_id'],
            subBr: _data[0]['responseData']['sub_brand_id'],
          );
          _loading = false;
        } else {
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
      appBar: defaultAppbar(context, '${_strController.adDetails}'),
      key: _scaffoldKey,
      body: _loading
          ? buildLoading(color: AppColors.redColor)
          : _statusCode == 410
              ? Directionality(
                  textDirection: AppController.textDirection,
                  child: Container(
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
                            "?????? ?????????????? ??????????",
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
                  ),
                )
              : Directionality(
                  textDirection: AppController.textDirection,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 5),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _data.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var _attributes =
                              _data[0]['responseData']['selected_attributes'];
                          var abuseReasons = _details['abuse_reasons'];
                          String status = _data[0]['responseData']['status'];
                          bool isPaused = _data[0]['responseData']['paused'];
                          var userContact = _details['user_contact'];
                          var relatedAds = _details['related_ads'];

                          // log('log:$relatedAds');
                          // print(_details['related_ads'].runtimeType);
                          return Form(
                            key: _formKeyAbuse,
                            autovalidateMode: AutovalidateMode.always,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                height: 50,
                                                width: 50,
                                                hasShadow: true,
                                                bgColor: AppColors.whiteColor,
                                                iconData: _details[
                                                            'is_favorite_ad'] ==
                                                        false
                                                    ? Icons.favorite_border
                                                    : Icons.favorite,
                                                color: Colors.red,
                                                size: 30,
                                                action: () {
                                                  favoriteAd(
                                                    scaffoldKey: _scaffoldKey,
                                                    context: context,
                                                    adId: _details['id'],
                                                    state: _details[
                                                                'is_favorite_ad'] ==
                                                            true
                                                        ? "delete"
                                                        : "add",
                                                  ).then((value) {
                                                    setState(() {
                                                      AdDetailsServicesNew
                                                          .getAdData(
                                                        adId: widget.adID,
                                                        slug: widget.slug,
                                                      ).then((value) {
                                                        setState(() {
                                                          _details[
                                                                  'is_favorite_ad'] =
                                                              !_details[
                                                                  'is_favorite_ad'];
                                                        });
                                                      });
                                                    });
                                                  });
                                                }),
                                          ))
                                    ],
                                  ),
                                ),
                                if (imageSliders.isNotEmpty &&
                                    imageSliders.length > 1)
                                  Container(
                                    height: mq.size.height * 0.255,
                                    child: Center(
                                      child: EnlargeStrategyDemo(
                                        imageSliders: imageSliders,
                                      ),
                                    ),
                                  ),
                                if (imageSliders.isNotEmpty &&
                                    imageSliders.length == 1)
                                  Container(
                                    height: mq.size.height * 0.255,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${_data[0]['responseData']['images'][0]['medium']}"),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if ('${userContact}' != '[]')
                                        Expanded(
                                          flex: 6,
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                  '${userContact['hash_id']}');
                                              return Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdvertiserProfile(
                                                            userContact[
                                                                'hash_id']),
                                                  ));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage: _details[
                                                                        'user_contact']
                                                                    [
                                                                    'user_image'] !=
                                                                null
                                                            ? NetworkImage(
                                                                userContact[
                                                                    'user_image'])
                                                            : AssetImage(
                                                                "assets/images/user_img.png"),
                                                      ),
                                                      CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor: _details[
                                                                'is_user_online']
                                                            ? AppColors
                                                                .greenColor
                                                            : AppColors.grey,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    userContact['nick_name'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: appStyle(
                                                        color: AppColors
                                                            .blackColor2,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      (_details['show_contact'] == true &&
                                              userContact != null &&
                                              (!widget.isPrivate &&
                                                  !isPaused &&
                                                  (status == 'approved' ||
                                                      status == 'new')))
                                          ? Expanded(
                                              flex: (userContact[
                                                          'mobile_number'] !=
                                                      null)
                                                  ? 5
                                                  : 1,
                                              child: Row(
                                                children: [
                                                  if (userContact[
                                                          'mobile_number'] !=
                                                      null)
                                                    buildIcons(
                                                      width: 35,
                                                      height: 35,
                                                      size: 15,
                                                      iconData: FontAwesomeIcons
                                                          .whatsapp,
                                                      color:
                                                          AppColors.whiteColor,
                                                      bgColor: AppColors.green,
                                                      action: () => launchWhatsApp(
                                                          userContact[
                                                                  'mobile_number']
                                                              .toString()),
                                                      // _launchURLWhatsApp(userContact['mobile_number'].toString());
                                                    ),
                                                  if (userContact[
                                                          'mobile_number'] !=
                                                      null)
                                                    buildIcons(
                                                        width: 35,
                                                        height: 35,
                                                        size: 15,
                                                        iconData:
                                                            FontAwesomeIcons
                                                                .phoneAlt,
                                                        bgColor: AppColors.blue,
                                                        color: AppColors
                                                            .whiteColor,
                                                        action: () {
                                                          // _launchCaller(userContact['mobile_number'].toString());
                                                          launch(
                                                              "tel://${userContact['mobile_number'].toString()}");
                                                        }),
                                                  buildIcons(
                                                    width: 35,
                                                    height: 35,
                                                    size: 15,
                                                    iconData: FontAwesomeIcons
                                                        .envelope,
                                                    color: AppColors.whiteColor,
                                                    bgColor: AppColors.redColor,
                                                    action: () {
                                                      buildMessage(
                                                          context: context);
                                                      // launch(
                                                      //     'mailto:${userContact['email'].toString()}');
                                                      // _launchURLEmail(
                                                      //   userContact
                                                      //           ['mobile_number']
                                                      //       .toString(),
                                                      // );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              flex: 1,
                                              child: Center(),
                                            ),
                                      if (!isPaused &&
                                          (status == 'approved' ||
                                              status == 'new'))
                                        buildIcons(
                                            width: 35,
                                            height: 35,
                                            size: 15,
                                            iconData: FontAwesomeIcons.shareAlt,
                                            bgColor: AppColors.greyFour,
                                            color: AppColors.whiteColor,
                                            action: () => shareData(context)),
                                    ],
                                  ),
                                ),
                                if (!_details['is_free'])
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 1),
                                      child: Container(
                                        color: AppColors.green.withOpacity(0.1),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16,
                                                        horizontal: 20),
                                                    width: double.infinity,
                                                    child: _details[
                                                                'has_price'] &&
                                                            _details['price'] !=
                                                                0 &&
                                                            _details[
                                                                    'currency'] !=
                                                                null
                                                        ? Text(
                                                            '${_details['price'].toString() + "  " + _details['currency']['ar'].toString()}',
                                                            style: appStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                        : Text(
                                                            _strController
                                                                .callAdvPrice,
                                                            style: appStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  if (widget.isPrivate &&
                                                      isPaused)
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16,
                                                          horizontal: 8),
                                                      width: double.infinity,
                                                      color:
                                                          AppColors.amberColor,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4),
                                                        child: buildTxt(
                                                            txt:
                                                                "?????? ???????????? ?????????? !",
                                                            fontSize: 18,
                                                            txtColor: AppColors
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  if (status == 'expired')
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16,
                                                          horizontal: 8),
                                                      width: double.infinity,
                                                      color:
                                                          AppColors.amberColor,
                                                      child: buildTxt(
                                                          txt:
                                                              "?????? ?????????????? ?????????? ???????????????? !",
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          txtColor: AppColors
                                                              .whiteColor),
                                                    )
                                                ],
                                              ),
                                            ),
                                            if (_details['negotiable'])
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                    '( ???????? ?????????????? )',
                                                    style: appStyle(
                                                        color: Colors.green,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_details['is_free'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
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
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.greyThree),
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              iconData:
                                                  FontAwesomeIcons.windows,
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
                                if (widget.isPrivate)
                                  if (_adBrands.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "??????????".toString(),
                                                    style: appStyle(
                                                        fontSize: 18,
                                                        color: AppColors
                                                            .blackColor2,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    _adBrands[0]['label']['ar']
                                                        .toString(),
                                                    style: appStyle(
                                                        fontSize: 16,
                                                        color: AppColors
                                                            .blackColor2
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w400),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "??????????".toString(),
                                                  style: appStyle(
                                                      fontSize: 18,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  _adSubBrands[0]['label']['ar']
                                                      .toString(),
                                                  style: appStyle(
                                                      fontSize: 18,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                          itemBuilder: (BuildContext context,
                                              int position) {
                                            var _myAttributes =
                                                _attributes[position];
                                            var _selectedValue =
                                                _myAttributes['selected_value'];
                                            var attributeName = (_selectedValue
                                                            .runtimeType ==
                                                        int ||
                                                    _selectedValue
                                                            .runtimeType ==
                                                        String ||
                                                    _selectedValue
                                                            .runtimeType ==
                                                        double)
                                                ? _selectedValue.toString()
                                                : _selectedValue.runtimeType
                                                            .toString() ==
                                                        "_InternalLinkedHashMap<String, dynamic>"
                                                    ? _selectedValue['label']
                                                            ['ar']
                                                        .toString()
                                                    : _selectedValue;
                                            var _myLabel =
                                                _attributes[position]['label'];
                                            var type =
                                                _myAttributes['config']['type'];
                                            // print('type:${_myAttributes['config']['type']}');
                                            // print('a type: ${attributeName.toString()}');
                                            return Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      _myLabel['ar'].toString(),
                                                      style: appStyle(
                                                        fontSize: 17,
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  if (_selectedValue.runtimeType
                                                          .toString() !=
                                                      "List<dynamic>")
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              attributeName
                                                                  .toString(),
                                                              style: appStyle(
                                                                  fontSize: 15,
                                                                  color: AppColors
                                                                      .greyFour,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          if (_attributes[
                                                                      position][
                                                                  'has_unit'] ==
                                                              1)
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    _attributes[position]['selected_unit_name']
                                                                            [
                                                                            'ar']
                                                                        .toString(),
                                                                    style: appStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: AppColors
                                                                            .greyFour,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
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
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 0),
                                                        child: GridView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                ClampingScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    type == 'multiple_color' ||
                                                                            type ==
                                                                                'color'
                                                                        ? 5
                                                                        : 2,
                                                                childAspectRatio:
                                                                    type == 'multiple_color' ||
                                                                            type ==
                                                                                'color'
                                                                        ? 2
                                                                        : 3),
                                                            itemCount:
                                                                attributeName
                                                                    .length,
                                                            itemBuilder:
                                                                (ctx, i) {
                                                              // log(attributeName.toString());
                                                              var _colorsHex;
                                                              var _colorsTxt;
                                                              if (type ==
                                                                      'multiple_color' ||
                                                                  type ==
                                                                      'color') {
                                                                _colorsHex =
                                                                    ("${attributeName[i]['name']}")
                                                                        .replaceAll(
                                                                            '#',
                                                                            '0xFF');
                                                                _colorsTxt =
                                                                    attributeName[i]
                                                                            [
                                                                            'label']
                                                                        ['ar'];
                                                              }
                                                              return type ==
                                                                          'multiple_color' ||
                                                                      type ==
                                                                          'color'
                                                                  ?attributeName[i]['name'] == 'other'
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
                                                                  ): Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            decoration: BoxDecoration(
                                                                                color: Color(
                                                                                  int.parse(_colorsHex),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(30),
                                                                                boxShadow: [
                                                                                  BoxShadow(color: AppColors.greyFour, offset: Offset(0.4, 0.4), spreadRadius: 0.4, blurRadius: 0.4)
                                                                                ]),
                                                                          ),
                                                                          // SizedBox(height: 5,),
                                                                          // Text(_colorsTxt.toString(),style: appStyle(color: AppColors.greyFour,fontSize: 12,fontWeight: FontWeight.bold),)
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          Text(
                                                                      attributeName[i]['label']['ar']
                                                                              .toString() +
                                                                          " , ",
                                                                      style: appStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: AppColors
                                                                              .greyFour,
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
                                              (BuildContext context,
                                                  int index) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (_details['show_contact'] == true)
                                        if (userContact['user_phone'] != null)
                                          Expanded(
                                            flex: 1,
                                            child: myButton(
                                                btnTxt: _strController.callAdv,
                                                fontSize: 16,
                                                btnColor:
                                                    Colors.lightBlueAccent,
                                                radius: 8,
                                                context: context,
                                                txtColor: AppColors.whiteColor,
                                                height: 35,
                                                onPressed: () {
                                                  launch(
                                                      "tel://${userContact['mobile_number'].toString()}");
                                                  // print('${_details['video']}');
                                                  //   if(_details['video'] != null)
                                                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideo(videoUrl: _details['video'],),),);
                                                }),
                                          ),
                                      if (_details['show_contact'] == true &&
                                          userContact['email'] != null)
                                        SizedBox(
                                          width: 10,
                                        ),
                                      if (!widget.isPrivate &&
                                          !isPaused &&
                                          (status == 'approved' ||
                                              status == 'new'))
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
                                                  buildMessage(context: context)
                                              // launch(
                                              // 'mailto:${userContact['email'].toString()}'),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (!isPaused &&
                                    (status == 'approved' ||
                                        status == 'new' ||
                                        status == 'edited'))
                                  if (!_details['is_abuse_ad'] && !reported)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      child: InkWell(
                                        onTap: () async {
                                          print(
                                              'REASON: ${abuseReasons.runtimeType}');
                                          await showInformationDialog(
                                              context, abuseReasons);
                                          // _buildAbuseDialog(
                                          //     context: context, details: abuseReasons);
                                        },
                                        child: buildTxt(
                                            txt: "?????? ???? ??????????",
                                            fontSize: 18,
                                            txtColor: AppColors.blue,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                if (_details['is_abuse_ad'] || reported)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: buildTxt(
                                        txt: '???????? ???? ?????? ?????????? ?????? ??????????????',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        txtColor: AppColors.amberColor),
                                  ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Column(
                                      children: [
                                        if (widget.isPrivate &&
                                            !isPaused &&
                                            (status == 'approved' ||
                                                status == 'new'))
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
                                            customTextAlign: (_) =>
                                                TextAlign.start,
                                            data: _details['body'],
                                            defaultTextStyle: appStyle(
                                                color: AppColors.blackColor2
                                                    .withOpacity(0.8),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        if (_details['video'] != null)
                                          myButton(
                                              btnTxt: '?????? ??????????????',
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
                                                        videoUrl:
                                                            _details['video'],
                                                      ),
                                                    ),
                                                  );
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                                if (relatedAds != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          buildTxt(
                                              txt: '?????????????? ????????????',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.start),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          relatedAdUi(relatedAds),
                                        ],
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: buildIconWithTxt(
                                          iconData: FontAwesomeIcons
                                              .exclamationTriangle,
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
                                        "???? ???????? ???? ?????????????? ?????????? ???? ?????? ???? ???? ?????????? ???? ???????? ???????????????? ?? ???? ???????????? ???????????? ???? ?????? ?????????????? ?? ?????????? ??????????????. ?? ???????? ?????????? ???? ?????????????????? ???????? ???????? ?????????? ???????????? ?? ?????????? ??????????????.",
                                        style: appStyle(
                                            color: AppColors.blackColor2
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }

  Future<void> buildMessage({BuildContext context}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Directionality(
          textDirection: AppController.textDirection,
          child: SingleChildScrollView(
            child: Container(
              child: buildTextField(
                validator: (value) => (_bodyController.text == null ||
                        _bodyController.text.isEmpty)
                    ? "???????? ?????????? ????????"
                    : null,
                label: "???? ??????????????",
                controller: _bodyController,
                minLines: 12,
                textInputType: TextInputType.multiline,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              flex: 5,
              child: buildTxt(
                  txt: '???????? ?????????? ?????? ???????????? ????????????????????',
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Align(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              Directionality(
                textDirection: AppController.textDirection,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: myButton(
                        height: 40,
                        onPressed: () {
                          sendMessage(
                            context: context,
                            adId: widget.adID,
                            txtBody: _bodyController.text.toString(),
                          ).then((value) {
                            if (value != 412) {
                              Navigator.of(context, rootNavigator: true).pop();
                              _bodyController.clear();
                            }
                          });
                        },
                        context: context,
                        btnTxt: _strController.done,
                        txtColor: AppColors.whiteColor,
                        fontSize: 18,
                        btnColor: AppColors.greenColor,
                        radius: 8,
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );

    Alert(
      context: context,
      title: " ???????? ?????????? ?????? ???????????? ????????????????",
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
                        ? "???????? ?????????? ????????"
                        : null,
                    label: "???? ??????????????",
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
            "??????????",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            sendMessage(
              context: context,
              adId: widget.adID,
              txtBody: _bodyController.text.toString(),
            ).then((value) {
              Navigator.of(context, rootNavigator: true).pop();
              _bodyController.clear();
            });
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  Future<void> showInformationDialog(BuildContext context, details) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                scrollable: true,
                content: SingleChildScrollView(
                  child: Container(
                    height: _showOtherReason
                        ? MediaQuery.of(context).size.height * 0.42
                        : MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: details.length,
                      itemBuilder: (ctx, index) {
                        return Column(
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
                            if (details[index]['id'] == 5 &&
                                _showOtherReason == true)
                              buildTextField(
                                label: "??????????",
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return '?????????? ?????? ??????????';
                                  }
                                  return null;
                                },
                                textInputType: TextInputType.text,
                                controller: _otherReason,
                                fromPhone: false,
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: buildTxt(
                          txt: '?????????????? ???? ?????????? ???? ????????????',
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: myButton(
                            height: 40,
                            onPressed: () {
                              final FormState form = _formKeyAbuse.currentState;
                              if (form.validate()) {
                                abuseAd(
                                        context: context,
                                        adId: widget.adID,
                                        abuseId: abuseID,
                                        abuseDescription:
                                            _otherReason.text.isNotEmpty
                                                ? _otherReason.text.toString()
                                                : null)
                                    .then((value) {
                                  if (value == "done") {
                                    setState(() {
                                      reported = true;
                                    });
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            },
                            context: context,
                            btnTxt: _strController.done,
                            txtColor: AppColors.whiteColor,
                            fontSize: 18,
                            btnColor: AppColors.greenColor,
                            radius: 8,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget relatedAdUi(List<dynamic> related) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _relatedLength,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            var _data = related[index];
            // bool hasPrice = _data['has_price'];
            return InkWell(
              onTap: () {
                print(_data['id'].toString());
                print(_data['slug']);
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      isPrivate: false,
                      adID: _data['id'],
                      slug: _data['slug'],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(8))),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        image: related[index]['images'] != null
                            ? NetworkImage(related[index]['images'][0]['image'])
                            // ? AssetImage("assets/images/1000.jpg")
                            : AssetImage("assets/images/1000.jpg"),
                      ),
                      // if(hasPrice)
                      if (_data['price'] != 0)
                        Container(
                          width: 200,
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            '${_data['price'].toString()} ?????????? ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 10,
        ),
        if (!_loadMore && _relatedAds.length >= 6)
          myButton(
              width: MediaQuery.of(context).size.width * 0.5,
              fontSize: 20,
              height: 25,
              context: context,
              txtColor: AppColors.whiteColor,
              radius: 8,
              btnColor: AppColors.blue,
              btnTxt: '?????? ????????????',
              onPressed: () {
                setState(() {
                  _relatedLength = _relatedAds.length;
                  _loadMore = true;
                  print('related: $_relatedLength');
                });
              }),
      ],
    );
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

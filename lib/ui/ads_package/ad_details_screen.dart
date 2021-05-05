import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'play_video.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsScreen extends StatefulWidget {
  final int adID;
  final String slug;

  AdDetailsScreen({@required this.adID, @required this.slug});

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  TextEditingController _otherReason = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int abuseID;
  String abuseReason;

  bool _showOtherReason = false;
  bool _loading = true;
  List _adDetails;
  List _adBrands;
  List _adSubBrands;
  int _selection = 0;
  int _brandId = 0;
  int _subBrandId = 0;
  List _sectionData;
  List _subSectionData;
  List _listImg = [];
  List<Widget> imageSliders;

  _getSections({int sec, int subSec, int br, int subBr}) async {
    SharedPreferences _gp = await SharedPreferences.getInstance();

    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      print('SUBSEC : $subSec');
      _sectionData = sections[0]['responseData'];
      // log("AAA : ${_sectionData[0] }");
      _sectionData =
          _sectionData.where((element) => element['id'] == sec).toList();
      // _subSectionData = _sectionData.where((element) => element['sub_sections']['id'] == sec).toList();
      _subSectionData = _sectionData[0]['sub_sections']
          .where((element) => (element['id'] == subSec))
          .toList();
      _adBrands = _subSectionData[0]['brands']
          .where((element) => (element['id'] == _brandId))
          .toList();
      _adSubBrands = _adBrands[0]['sub_brands']
          .where((element) => (element['id'] == _subBrandId))
          .toList();
      // _adSubBrands = _adBrands[0]['sub_brands'];
    });
  }

  @override
  void initState() {
    _selection = 1;
    AdDetailsServicesNew.getAdData(adId: widget.adID, slug: widget.slug)
        .then((value) {
      setState(() {
        _adDetails = value;
        if (_adDetails[0]['responseData']['images'] != null)
          for (var links in _adDetails[0]['responseData']['images']) {
            _listImg.add(links['medium']);
          }
        if (_listImg != null || _listImg != [])
          imageSliders = _listImg
              .map((item) => Container(
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
                          )),
                    ),
                  ))
              .toList();
        // _sliderImages = _adDetails[0]['responseData']['images'];
        // print('Ad Details : ${_adDetails}');
        _brandId = _adDetails[0]['responseData']['brand_id'];
        _subBrandId = _adDetails[0]['responseData']['sub_brand_id'];

        // log('_sliderImages: $_sliderImages');
        _getSections(
          sec: _adDetails[0]['responseData']['section_id'],
          subSec: _adDetails[0]['responseData']['sub_section_id'],
          br: _adDetails[0]['responseData']['brand_id'],
          subBr: _adDetails[0]['responseData']['sub_brand_id'],
        );
        _loading = false;
      });
    });
    super.initState();
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

  void share(BuildContext context) {
    final String text = "http:www.kulshe.com";
    RenderBox box = context.findRenderObject();
    Share.share(text,
        subject: text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(bgColor: AppColors.whiteColor, centerTitle: true),
        backgroundColor: Colors.white,
        body: _loading
            ? buildLoading(color: AppColors.redColor)
            : Directionality(
                textDirection: _drController,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _adDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            var _details = _adDetails[0]['responseData'];
                            var _attributes = _adDetails[0]['responseData']
                                ['selected_attributes'];
                            var abuseReasons = _details['abuse_reasons'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                _details['title'].toString(),
                                                style: appStyle(
                                                  fontSize: 14,
                                                  color: AppColors.blackColor2,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: buildIcons(
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
                                                                  adId: widget
                                                                      .adID,
                                                                  slug: widget
                                                                      .slug)
                                                          .then((value) {
                                                        setState(() {
                                                          _adDetails = value;
                                                          // _adDetailsData = value[0]['responseData'];
                                                          // _detailsAttribute = value[0]['responseData']['selected_attributes'];
                                                          _loading = false;
                                                        });
                                                      });
                                                    });
                                                  });
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (!_details['is_free'])
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: double.infinity,
                                              child: _details['has_price'] &&
                                                      _details['price'] != 0 &&
                                                      _details['currency'] !=
                                                          null
                                                  ? Text(
                                                      '${_details['price'].toString()}${_details['currency']['ar'].toString()}',
                                                      style: appStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  : Text(
                                                      _strController
                                                          .callAdvPrice,
                                                      style: appStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                            ),
                                          ),
                                          if (_details['negotiable'])
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                '(قابل للتفاوض)',
                                                style: appStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                        ],
                                      ),
                                    if (_details['is_free'])
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                if (imageSliders.isNotEmpty)
                                  Container(
                                      height: mq.size.height * 0.25,
                                      child: EnlargeStrategyDemo(
                                        imageSliders: imageSliders,
                                      )),
                                // adsWidget(_details['images']),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_details['show_contact'] &&
                                    _details['user_contact'] != null &&
                                    _details['user_contact']['user_image'] !=
                                        null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            _details['user_contact']
                                                ['user_image']),
                                      ),
                                      Text(
                                        _details['user_contact']['nick_name'],
                                        style: appStyle(
                                            color: AppColors.blackColor2,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      buildIcons(
                                        iconData: FontAwesomeIcons.whatsapp,
                                        color: AppColors.whiteColor,
                                        bgColor: AppColors.green,
                                        action: () => launchWhatsApp(
                                            _details['user_contact']
                                                    ['mobile_number']
                                                .toString()),
                                        // _launchURLWhatsApp(_details['user_contact']['mobile_number'].toString());
                                      ),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.phoneAlt,
                                          bgColor: AppColors.blue,
                                          color: AppColors.whiteColor,
                                          action: () {
                                            // _launchCaller(_details['user_contact']['mobile_number'].toString());
                                            launch(
                                                "tel://${_details['user_contact']['mobile_number'].toString()}");
                                          }),
                                      buildIcons(
                                        iconData: FontAwesomeIcons.envelope,
                                        color: AppColors.whiteColor,
                                        bgColor: AppColors.redColor,
                                        action: () {
                                          launch(
                                              'mailto:${_details['user_contact']['email'].toString()}');
                                          // _launchURLEmail(
                                          //   _details['user_contact']
                                          //           ['mobile_number']
                                          //       .toString(),
                                          // );
                                        },
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_adBrands.isNotEmpty)
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "النوع".toString(),
                                            style: appStyle(
                                                fontSize: 18,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            _adBrands[0]['label']['ar']
                                                .toString(),
                                            style: appStyle(
                                                fontSize: 18,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 10,
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
                                                flex: 3,
                                                child: Text(
                                                  "الفرع".toString(),
                                                  style: appStyle(
                                                      fontSize: 18,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
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
                                        Divider(
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
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
                                            _selectedValue.runtimeType ==
                                                String ||
                                            _selectedValue.runtimeType ==
                                                double)
                                        ? _selectedValue.toString()
                                        : _selectedValue.runtimeType
                                                    .toString() ==
                                                "_InternalLinkedHashMap<String, dynamic>"
                                            ? _selectedValue['name']['ar']
                                                .toString()
                                            : _selectedValue;
                                    var _myLabel =
                                        _attributes[position]['label'];

                                    // print('a type: ${attributeName.toString()}');
                                    return Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                _myLabel['ar'].toString(),
                                                style: appStyle(
                                                    fontSize: 18,
                                                    color: AppColors.blackColor,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          if (_selectedValue.runtimeType
                                                  .toString() !=
                                              "List<dynamic>")
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                attributeName.toString(),
                                                style: appStyle(
                                                    fontSize: 16,
                                                    color:
                                                        AppColors.blackColor2,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          if (_selectedValue.runtimeType
                                                  .toString() ==
                                              "List<dynamic>")
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0),
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            childAspectRatio:
                                                                3),
                                                    itemCount:
                                                        attributeName.length,
                                                    itemBuilder: (ctx, index) {
                                                      return Center(
                                                          child: Text(
                                                        attributeName[index]
                                                                        ['name']
                                                                    ['ar']
                                                                .toString() +
                                                            " , ",
                                                        style: appStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Text(
                                      _strController.callAdv,
                                      style: appStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: myButton(
                                              btnTxt: _strController.callAdv,
                                              fontSize: 16,
                                              btnColor: Colors.lightBlueAccent,
                                              radius: 8,
                                              context: context,
                                              txtColor: AppColors.whiteColor,
                                              height: 45,
                                              onPressed: () {
                                                launch(
                                                    "tel://${_details['user_contact']['mobile_number'].toString()}");
                                                // print('${_details['video']}');
                                                //   if(_details['video'] != null)
                                                //   Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideo(videoUrl: _details['video'],),),);
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: myButton(
                                            btnTxt: _strController.sendEmail,
                                            fontSize: 16,
                                            btnColor: Colors.lightBlueAccent,
                                            radius: 8,
                                            context: context,
                                            txtColor: AppColors.whiteColor,
                                            height: 45,
                                            onPressed: () => launch(
                                                'mailto:${_details['user_contact']['email'].toString()}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    myButton(
                                        btnTxt: 'عرض الفيديو',
                                        fontSize: 16,
                                        btnColor: Colors.amber,
                                        radius: 8,
                                        context: context,
                                        txtColor: AppColors.whiteColor,
                                        height: 45,
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
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // buildIcons(
                                      //     iconData: FontAwesomeIcons.facebookF,
                                      //     bgColor: Colors.blue,
                                      //     color: AppColors.whiteColor,
                                      //     action: ()=>shareData(context)),
                                      // buildIcons(
                                      //     iconData: FontAwesomeIcons.instagram,
                                      //     color: AppColors.whiteColor,
                                      //     bgColor: Colors.deepOrangeAccent,
                                      //     action: () {}),
                                      // buildIcons(
                                      //     iconData: FontAwesomeIcons.twitter,
                                      //     bgColor: Colors.lightBlueAccent,
                                      //     color: AppColors.whiteColor,
                                      //     action: () {}),
                                      // buildIcons(
                                      //     iconData: FontAwesomeIcons.linkedinIn,
                                      //     color: AppColors.whiteColor,
                                      //     bgColor: AppColors.blue,
                                      //     action: () {}),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(
                                        'REASON: ${abuseReasons.runtimeType}');
                                    _buildAbuseDialog(
                                        context: context,
                                        details: abuseReasons);
                                  },
                                  child: buildTxt(
                                      txt: "Report abuse",
                                      fontSize: 22,
                                      txtColor: AppColors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Text(
                                      _strController.adDetails,
                                      style: TextStyle(
                                          color: Colors.black,
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
                                          color: AppColors.blackColor2,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )

                                    // Text(
                                    //   _details['body']+'sss',
                                    //   //  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                                    //   style: appStyle(
                                    //       color: AppColors.blackColor2,
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.w500),
                                    // )
                                    ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // buildTextField(label: _strController.email),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // myButton(
                                //     fontSize: 20,
                                //     width: double.infinity,
                                //     onPressed: () => print(''),
                                //     height: 45,
                                //     txtColor: AppColors.whiteColor,
                                //     context: context,
                                //     btnColor: AppColors.redColor,
                                //     btnTxt: _strController.mobile,
                                //     radius: 10),
                                SizedBox(
                                  height: 40,
                                ),
                                buildIconWithTxt(
                                  iconData:
                                      FontAwesomeIcons.exclamationTriangle,
                                  iconColor: Colors.amber,
                                  size: 25,
                                  label: Text(
                                    _strController.warning,
                                    style: appStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blackColor2),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "لا ترسل أي معلومات شخصية أو صور أو أي أموال من خلال الإنترنت و قم بالازم للتأكد من صحة الإعلان و الجهة المعلنة. و توخى الحذر من الإعلانات التي تروج الربح السريع و تزوير الوثائق.",
                                  style: appStyle(
                                      color: AppColors.blackColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _buildAbuseDialog(
      {BuildContext context, List<dynamic> details, Function action}) {
    return Alert(
      context: context,
      title: "Report Abuse",
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
            "Submit",
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
                    : null);
            Navigator.of(context, rootNavigator: true).pop();
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

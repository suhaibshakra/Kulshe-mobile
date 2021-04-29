import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/profile/advertiser_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_details_screen.dart';

class PublicAdsListScreen extends StatefulWidget {
  final sectionId;
  final subSectionId;
  final subSection;
  final txt;
  final section;
  final isFav;

  PublicAdsListScreen(
      {this.sectionId,
      this.subSectionId,
      this.subSection,
      this.txt,
      this.section,
      this.isFav});

  @override
  _PublicAdsListScreenState createState() => _PublicAdsListScreenState();
}

class _PublicAdsListScreenState extends State<PublicAdsListScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;

  //270

  bool isLiked = false;
  bool _loading = true;
  List _publicAd;

  bool isList;

  Color iconListColor;

  bool isChecked;
  String _chosenValue;
  String sectionTitle;
  String subSectionTitle;

  int offset = 0;
  int limit = 10;
  String countOfAds;
  double countOfPager;
  String sorting;
  String lang;
  List _currentCountry;
  List _countryData;

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    _countryData = countries[0]['responseData'];
    setState(() {
      _countryData = _countryData
          .where((element) => element['classified'] == true)
          .toList();
      _currentCountry = _countryData
          .where((element) =>
              element['id'].toString() == _gp.getString('countryId'))
          .toList();
      //print('CURRENT : $_currentCountry');
    });
    //print('_${_countryData.where((element) => element['classified'] == true)}');
    // print(sections[0].responseData[4].name);
  }

  _getLang() async {
    SharedPreferences _pr = await SharedPreferences.getInstance();
    setState(() {
      lang = _pr.getString('lang');
    });
  }

  @override
  void initState() {
    super.initState();
    // _getSections();
    print(widget.sectionId);
    print(widget.subSectionId);
    _getCountries();
    _getLang();
    setState(() {
      isList = true;
      iconListColor = AppColors.redColor;
      isChecked = false;
    });
    // print('ID : ${widget.sectionId}');
    // print('SUB ID : ${widget.subSectionId}');
    if (widget.isFav)
      FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
          .then((value) {
        setState(() {
          _publicAd = value[0]['responseData']['ads'];
          countOfAds = (value[0]['responseData']['total']).toString();
          countOfPager = (double.parse(countOfAds) / 10);
          countOfPager = countOfPager.ceil().toDouble();
          _loading = false;
        });
      });

    if (!widget.isFav)
      PublicAdsServicesNew.getPublicAdsData(
              sectionId: widget.sectionId,
              subSectionId: widget.subSectionId,
              txt: widget.txt,
              offset: '$offset',
              countryId: 110,
              hasImage: 0,
              sort: sorting,
              hasPrice: '',
              limit: '$limit')
          .then((value) {
        setState(() {
          print('-------------------------------------------------');
          print('${widget.txt}');
          print('-------------------------------------------------');
          _publicAd = value[0]['responseData']['ads'];
          countOfAds = (value[0]['responseData']['total']).toString();
          // print('count of ads : ${countOfAds.toString()}');
          countOfPager = (double.parse(countOfAds) / 10);
          countOfPager = countOfPager.ceil().toDouble();
          // print("CEIL : " + countOfPager.toString());
          // print('ADS Data: ${_publicAd}');
          _loading = false;
          // print('_publicAd : ${_publicAd.length}');
        });
      });
  }

  void toggleCheckbox(bool value) {
    if (isChecked == false) {
      // Put your code here which you want to execute on CheckBox Checked event.
      if (widget.isFav)
        FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            _loading = false;
          });
        });
      if (!widget.isFav)
        PublicAdsServicesNew.getPublicAdsData(
                sectionId: widget.sectionId,
                subSectionId: widget.subSectionId,
                txt: widget.txt,
                offset: '$offset',
                countryId: 110,
                hasImage: 1,
                sort: sorting,
                hasPrice: '',
                limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            _loading = false;
          });
        });
      setState(() {
        isChecked = true;
      });
    } else {
      // Put your code here which you want to execute on CheckBox Un-Checked event.
      if (widget.isFav)
        FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            _loading = false;
          });
        });
      if (!widget.isFav)
        PublicAdsServicesNew.getPublicAdsData(
                sectionId: widget.sectionId,
                subSectionId: widget.subSectionId,
                txt: widget.txt,
                offset: '$offset',
                countryId: 110,
                hasImage: 0,
                sort: sorting,
                hasPrice: '',
                limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            _loading = false;
          });
        });
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Directionality(
        textDirection: _drController,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: buildAppBar(
              centerTitle: true,
              bgColor: AppColors.whiteColor,
              themeColor: Colors.grey),
          // drawer: buildDrawer(context),
          backgroundColor: Colors.grey.shade200,
          body: _loading
              ? buildLoading(color: AppColors.green)
              : Stack(
                  children: [
                    buildBg(),
                    SingleChildScrollView(
                      child: Container(
                        color: AppColors.whiteColor,
                        child: Column(
                          children: [
                            if(!widget.isFav)
                              Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    width: double.infinity,
                                    child: buildTxt(
                                      txt: "${widget.section}",
                                      fontSize: 18,
                                      txtColor: Colors.black,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                  _buildPath(),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            buildFilter(),
                            SizedBox(
                              height: 22,
                            ),
                            if (isList) buildListOneItem(mq),
                            if (isList == false) buildGridList(mq),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(countOfPager.toString()),
                                OutlineButton(
                                  onPressed: goToPrevious,
                                  child: Text("< previous"),
                                ),
                                OutlineButton(
                                  onPressed: goToNext,
                                  child: Text(" next >"),
                                ),
                                Text(countOfAds.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Container buildGridList(MediaQueryData mq) {
    return Container(
      child: GridView.builder(
        itemCount: _publicAd.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          int imgStatus = _publicAd[index]['count_of_images'];
          var _data = _publicAd[index];
          return Stack(
            children: [
              InkWell(
                onTap: () {
                  print(_data['id'].toString());
                  print(_data['slug']);
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdDetailsScreen(
                          adID: _data['id'], slug: _data['slug']),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(1, 1),
                              spreadRadius: 1,
                              blurRadius: 1)
                        ]),
                    child: Card(
                      color: AppColors.whiteColor,
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: mq.size.height * 0.16,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8)),
                                image: DecorationImage(
                                  fit: imgStatus >= 1
                                      ? BoxFit.cover
                                      : BoxFit.contain,
                                  image: imgStatus >= 1
                                      ? NetworkImage(_data['images'][0]['image']
                                          .toString())
                                      : AssetImage("assets/images/no_img.png"),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: buildIcons(
                                        iconData:
                                            _data['is_favorite_ad'] == false
                                                ? Icons.favorite_border
                                                : Icons.favorite,
                                        color: Colors.red,
                                        size: 26,
                                        action: () {
                                          favoriteAd(
                                            context: context,
                                            adId: _data['id'],
                                            state:
                                                _data['is_favorite_ad'] == true
                                                    ? "delete"
                                                    : "add",
                                          ).then((value) {
                                            setState(() {
                                              if(widget.isFav)
                                                FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
                                                    .then((value) {
                                                  setState(() {
                                                    _publicAd = value[0]['responseData']['ads'];
                                                    countOfAds =
                                                        (value[0]['responseData']['total']).toString();
                                                    print('count of ads : ${countOfAds.toString()}');
                                                    _loading = false;
                                                  });
                                                });
                                              if(!widget.isFav)
                                                PublicAdsServicesNew
                                                      .getPublicAdsData(
                                                          sectionId:
                                                              widget.sectionId,
                                                          subSectionId: widget
                                                              .subSectionId,
                                                          txt: widget.txt,
                                                          offset: '',
                                                          countryId: 110,
                                                          hasImage: 0,
                                                          hasPrice: '',
                                                          limit: '')
                                                  .then((value) {
                                                setState(() {
                                                  _publicAd = value[0]
                                                      ['responseData']['ads'];
                                                  // print('ADS Data: ${_publicAd}');
                                                  _loading = false;
                                                  // print('_publicAd : ${_publicAd.length}');
                                                });
                                              });
                                            });
                                          });
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: mq.size.width * 0.32,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                myIcon(
                                                    context, Icons.video_call,
                                                    color: Colors.white,
                                                    size: 25,
                                                    hasDecoration: false),
                                                buildTxt(
                                                    txt: (_data['video'] ==
                                                                    null ||
                                                                _data['video'] ==
                                                                    ""
                                                            ? "0"
                                                            : 1)
                                                        .toString(),
                                                    txtColor:
                                                        AppColors.whiteColor)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                myIcon(
                                                    context, Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 25,
                                                    hasDecoration: false),
                                                buildTxt(
                                                    txt:
                                                        _data['count_of_images']
                                                            .toString(),
                                                    txtColor:
                                                        AppColors.whiteColor)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (_data['show_contact'] != false)
                                    InkWell(

                                      onTap: (){

                                        return Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertiserProfile('zoJyY'),));
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: _data['user_contact']
                                                    ['user_image'] !=
                                                null
                                            ? NetworkImage(_data['user_contact']
                                                ['user_image'])
                                            : AssetImage(
                                                "assets/images/no_img.png"),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: Container(
                                      width: mq.size.width * 0.2,
                                      child: Text(
                                        _data['title'],
                                        style: appStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  _data['body'],
                                  // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                  style: appStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (_data['has_price'] &&
                                _data['currency'] != null &&
                                _data['currency'] != 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '${_data['price'].toString()}  ${_data['currency'][lang].toString()}',
                                    style: appStyle(
                                        fontSize: 16, color: AppColors.green),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: mq.size.width < 400
                ? 2
                : mq.size.width >= 400 && mq.size.width < 620
                    ? 3
                    : 4,
            childAspectRatio: 0.65),
      ),
    );
  }

  Container buildListOneItem(MediaQueryData mq) {
    return Container(
      child: ListView.builder(
          itemCount: _publicAd.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int imgStatus = _publicAd[index]['count_of_images'] != null
                ? _publicAd[index]['count_of_images']
                : 0;
            var _data = _publicAd[index];

            // print(_data['user_contact'].toString() +'---------------'+_data['id'].toString());
            // print(
            //     'ISFAV ${_data['is_favorite_ad']} , ${_data['id']} , ${_data['slug']} ');

            return InkWell(
              onTap: () {
                print(_data['id'].toString());
                print(_data['slug']);
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdDetailsScreen(adID: _data['id'], slug: _data['slug']),
                  ),
                );
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(1, 1),
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                      child: Card(
                        color: AppColors.whiteColor,
                        elevation: 6,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: mq.size.height * 0.22,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: imgStatus >= 1
                                        ? BoxFit.cover
                                        : BoxFit.contain,
                                    image: imgStatus >= 1
                                        ? NetworkImage(_data['images'][0]
                                                ['image']
                                            .toString())
                                        : AssetImage(
                                            "assets/images/no_img.png"),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: buildIcons(
                                          iconData:
                                              _data['is_favorite_ad'] == false
                                                  ? Icons.favorite_border
                                                  : Icons.favorite,
                                          color: Colors.red,
                                          size: 25,
                                          action: () {
                                            favoriteAd(
                                              context: context,
                                              adId: _data['id'],
                                              state: _data['is_favorite_ad'] ==
                                                      true
                                                  ? "delete"
                                                  : "add",
                                            ).then((value) {
                                              setState(() {
                                                  if(widget.isFav)
                                                    FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
                                                        .then((value) {
                                                      setState(() {
                                                        _publicAd = value[0]['responseData']['ads'];
                                                        countOfAds =
                                                            (value[0]['responseData']['total']).toString();
                                                        print('count of ads : ${countOfAds.toString()}');
                                                        _loading = false;
                                                      });
                                                    });
                                                if(!widget.isFav)
                                                PublicAdsServicesNew
                                                        .getPublicAdsData(
                                                            sectionId: widget
                                                                .sectionId,
                                                            subSectionId: widget
                                                                .subSectionId,
                                                            txt: widget.txt,
                                                            offset: '',
                                                            countryId: 110,
                                                            hasImage: 0,
                                                            hasPrice: '',
                                                            limit: '')
                                                    .then((value) {
                                                  setState(() {
                                                    _publicAd = value[0]
                                                        ['responseData']['ads'];
                                                    // print('ADS Data: ${_publicAd}');
                                                    _loading = false;
                                                    // print('_publicAd : ${_publicAd.length}');
                                                  });
                                                });
                                              });
                                            });
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            width: mq.size.width * 0.32,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  children: [
                                                    myIcon(context,
                                                        Icons.video_call,
                                                        color: Colors.white,
                                                        size: 25,
                                                        hasDecoration: false),
                                                    buildTxt(
                                                        txt: (_data['video'] ==
                                                                    null
                                                                ? "0"
                                                                : 1)
                                                            .toString(),
                                                        txtColor: AppColors
                                                            .whiteColor)
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    myIcon(context,
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                        size: 25,
                                                        hasDecoration: false),
                                                    buildTxt(
                                                        txt: _data[
                                                                'count_of_images']
                                                            .toString(),
                                                        txtColor: AppColors
                                                            .whiteColor)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          myIcon(
                                              context, FontAwesomeIcons.windows,
                                              color: Colors.black54,
                                              size: 25,
                                              hasDecoration: false),
                                          buildTxt(
                                              txt: (widget.section).toString(),
                                              txtColor: Colors.black54)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          myIcon(context, Icons.alarm,
                                              color: Colors.black54,
                                              size: 25,
                                              hasDecoration: false),
                                          buildTxt(
                                              txt:
                                                  // TimeAgo.timeAgoSinceDate
                                                  (_data['created_at'])
                                                      .toString(),
                                              txtColor: Colors.black54)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (_data['show_contact'] != false &&
                                        _data['user_contact'] != null)
                                      InkWell(
                                        onTap: (){

                                          return Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertiserProfile('zoJyY'),));
                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: _data['user_contact']
                                                      ['user_image'] !=
                                                  null
                                              ? NetworkImage(_data['user_contact']
                                                  ['user_image'])
                                              : AssetImage(
                                                  "assets/images/no_img.png"),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 16.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          _data['title'],
                                          style: appStyle(
                                              fontSize: 16,
                                              color: AppColors.blackColor),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    _data['body'],
                                    // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                    style: appStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if ((_data['has_price'] &&
                                      _data['currency'] != null) && _data['is_free'] == false&&
                                  _data['price'] != 0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      '${_data['price'].toString()}  ${_data['currency'][lang].toString()}',
                                      style: appStyle(
                                          fontSize: 18, color: AppColors.green),
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              // if (_data['has_price']==flase && _data['price'] == 0)
                              //   Text(""),

                                if(_data['is_free'])
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      _strController.free,
                                      style: appStyle(
                                          fontSize: 16,
                                          color: AppColors.greenColor),
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Container buildFilter() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: widget.isFav?MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 50,
                color: AppColors.whiteColor,
                child: Row(
                  children: [
                    buildIcons(
                        iconData: FontAwesomeIcons.listUl,
                        hasShadow: true,
                        bgColor: AppColors.grey.withOpacity(0.2),
                        color: isList ? iconListColor : AppColors.grey,
                        action: () {
                          setState(() {
                            isList = true;
                          });
                        }),
                    buildIcons(
                        iconData: FontAwesomeIcons.windows,
                        hasShadow: true,
                        bgColor: AppColors.grey.withOpacity(0.2),
                        color: isList ? AppColors.grey : iconListColor,
                        action: () {
                          setState(() {
                            isList = false;
                          });
                        }),
                  ],
                ),
              ),
              if(!widget.isFav)
                Container(
                width: MediaQuery.of(context).size.width * 0.3,
                color: AppColors.whiteColor,
                child: Row(
                  children: [
                    buildTxt(txt: _strController.withImages),
                    Transform.scale(
                      scale: 1,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          toggleCheckbox(value);
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        tristate: false,
                      ),
                    ),
                  ],
                ),
              ),
              if(!widget.isFav)
                Container(
                width: MediaQuery.of(context).size.width * 0.4,
                color: AppColors.whiteColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _chosenValue,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),
                    items: <String>[
                      _strController.oldToNew,
                      _strController.newToOld,
                      _strController.priceHighToLess,
                      _strController.priceLessToHigh,
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: appStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      _strController.orderBy,
                      style: appStyle(
                          color: AppColors.blackColor2,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                        sorting = (_chosenValue == _strController.oldToNew)
                            ? "OldToNew"
                            : (_chosenValue == _strController.newToOld)
                                ? "NewToOld"
                                : (_chosenValue ==
                                        _strController.priceLessToHigh)
                                    ? "priceLessToHigh"
                                    : "priceHighToLess";
                        if(widget.isFav)
                            FavoriteAdsServices.getFavData(offset: '$offset', limit: '$limit')
                                .then((value) {
                              setState(() {
                                _publicAd = value[0]['responseData']['ads'];
                                countOfAds =
                                    (value[0]['responseData']['total']).toString();
                                print('count of ads : ${countOfAds.toString()}');
                                _loading = false;
                              });
                            });
                        if(!widget.isFav)
                        PublicAdsServicesNew.getPublicAdsData(
                                sectionId: widget.sectionId,
                                subSectionId: widget.subSectionId,
                                txt: widget.txt,
                                offset: '$offset',
                                countryId: 110,
                                hasImage: 0,
                                sort: sorting.toString(),
                                hasPrice: '',
                                limit: '$limit')
                            .then((value) {
                          setState(() {
                            _publicAd = value[0]['responseData']['ads'];
                            countOfAds =
                                (value[0]['responseData']['total']).toString();
                            print('count of ads : ${countOfAds.toString()}');
                            _loading = false;
                          });
                        });
                        print('Sorting : $sorting');
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
                  fontSize: 12,
                  txtColor: AppColors.blackColor2,
                  fontWeight: FontWeight.w500,
                  txt: "${_currentCountry[0]['label'][lang]}",
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
                  fontSize: 12,
                  txtColor: AppColors.blackColor2,
                  fontWeight: FontWeight.w500,
                  txt: "${_currentCountry[0]['cities'][0]['label']['ar']}",
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
                  fontSize: 12,
                  maxLine: 1,
                  txtColor: AppColors.blackColor2,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  txt: "${widget.section}",
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
                  fontSize: 12,
                  maxLine: 1,
                  txtColor: AppColors.blackColor2,
                  fontWeight: FontWeight.w500,
                  txt: "${widget.subSection}",
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  goToPrevious() {
    setState(() {
      _loading = true;
      if (widget.isFav)
        FavoriteAdsServices.getFavData(offset: '${offset >= 10 && offset != 0 ? offset -= 10 : offset}', limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            countOfPager = (double.parse(countOfAds) / 10);
            countOfPager = countOfPager.ceil().toDouble();
            print("CEIL : " + countOfPager.toString());
            print('OFFSET = $offset');
            // print('ADS Data: ${_publicAd}');
            _loading = false;
            // print('_publicAd : ${_publicAd.length}');
          });
        });
      if(!widget.isFav)
      PublicAdsServicesNew.getPublicAdsData(
              sectionId: widget.sectionId,
              subSectionId: widget.subSectionId,
              txt: widget.txt,
              offset: '${offset >= 10 && offset != 0 ? offset -= 10 : offset}',
              countryId: 110,
              hasImage: isChecked ? 1 : 0,
              hasPrice: '',
              sort: sorting,
              limit: '$limit')
          .then((value) {
        setState(() {
          _publicAd = value[0]['responseData']['ads'];
          countOfAds = (value[0]['responseData']['total']).toString();
          print('count of ads : ${countOfAds.toString()}');
          countOfPager = (double.parse(countOfAds) / 10);
          countOfPager = countOfPager.ceil().toDouble();
          print("CEIL : " + countOfPager.toString());
          print('OFFSET = $offset');
          // print('ADS Data: ${_publicAd}');
          _loading = false;
          // print('_publicAd : ${_publicAd.length}');
        });
      });
    });
  }

  goToNext() {
    setState(() {
      _loading = true;
      if (widget.isFav)
        FavoriteAdsServices.getFavData(offset: '${int.parse(countOfAds) > (offset + 10) ? offset += 10 : offset}', limit: '$limit')
            .then((value) {
          setState(() {
            _publicAd = value[0]['responseData']['ads'];
            countOfAds = (value[0]['responseData']['total']).toString();
            print('count of ads : ${countOfAds.toString()}');
            countOfPager = (double.parse(countOfAds) / 10);
            countOfPager = countOfPager.ceil().toDouble();
            print("CEIL : " + countOfPager.toString());
            print('OFFSET = $offset');
            // print('ADS Data: ${_publicAd}');
            _loading = false;
            // print('_publicAd : ${_publicAd.length}');
          });
        });
      if(!widget.isFav)
      PublicAdsServicesNew.getPublicAdsData(
              sectionId: widget.sectionId,
              subSectionId: widget.subSectionId,
              txt: widget.txt,
              offset:
                  '${int.parse(countOfAds) > (offset + 10) ? offset += 10 : offset}',
              countryId: 110,
              hasImage: isChecked ? 1 : 0,
              hasPrice: '',
              sort: sorting,
              limit: '$limit')
          .then((value) {
        setState(() {
          _publicAd = value[0]['responseData']['ads'];
          countOfAds = (value[0]['responseData']['total']).toString();
          print('count of ads : ${countOfAds.toString()}');
          countOfPager = (double.parse(countOfAds) / 10);
          countOfPager = countOfPager.ceil().toDouble();
          print("CEIL : " + countOfPager.toString());
          print('OFFSET = $offset');
          // print('ADS Data: ${_publicAd}');
          _loading = false;
          // print('_publicAd : ${_publicAd.length}');
        });
      });
    });
  }
}

// class TimeAgo {
//   static String timeAgoSinceDate(String dateString,
//       {bool numericDates = true}) {
//     DateTime notificationDate =
//         DateFormat("yyyy-dd-MM\Thh:mm:sssssssssssssss\Z").parse(dateString);
//     final date2 = DateTime.now();
//     final difference = date2.difference(notificationDate);
//
//     if (difference.inDays > 8) {
//       return dateString;
//     } else if ((difference.inDays / 7).floor() >= 1) {
//       return (numericDates) ? '1 week ago' : 'Last week';
//     } else if (difference.inDays >= 2) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inDays >= 1) {
//       return (numericDates) ? '1 day ago' : 'Yesterday';
//     } else if (difference.inHours >= 2) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inHours >= 1) {
//       return (numericDates) ? '1 hour ago' : 'An hour ago';
//     } else if (difference.inMinutes >= 2) {
//       return '${difference.inMinutes} minutes ago';
//     } else if (difference.inMinutes >= 1) {
//       return (numericDates) ? '1 minute ago' : 'A minute ago';
//     } else if (difference.inSeconds >= 3) {
//       return '${difference.inSeconds} seconds ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }

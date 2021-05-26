import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/time_ago.dart';
import 'package:kulshe/ui/profile/advertiser_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_ad/edit_ad_form.dart';
import 'details_screen.dart';

class PublicAdsScreen extends StatefulWidget {
  final sectionId;
  final subSectionId;
  final subSection;
  final txt;
  final actionTitle;
  final isPrivate;
  var section;
  var isFav;
  var fromHome;
  final isFilter;
  final filteredData;

  PublicAdsScreen(
      {Key key,
      this.sectionId,
      this.subSectionId,
      this.subSection,
      this.txt,
      this.section,
      this.isFav,
      this.isFilter,
      this.filteredData,
      this.fromHome,
      this.actionTitle,
      this.isPrivate})
      : super(key: key);

  @override
  _PublicAdsScreenState createState() => _PublicAdsScreenState();
}

class _PublicAdsScreenState extends State<PublicAdsScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  String lang;
  List _currentCountry;
  List _countryData;
  String sorting = '';
  int offset = 0;
  int limit = 10;
  bool isChecked = false;
  bool _loading = true;
  List _publicAd;
  num _num = 0;
  String _subSectionText;
  List _sectionData;
  List _subSectionData;
  String _sectionText;
  String _chosenValue;
  bool _privateBool;

  _getSections({int sec, int subSec}) async {
    print("_getSections : Start");
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      _sectionData =
          _sectionData.where((element) => element['id'] == sec).toList();
      _sectionText = _sectionData[0]['label']['ar'];
      _subSectionData = _sectionData[0]['sub_sections']
          .where((element) => (element['id'] == subSec))
          .toList();
      _subSectionText = _subSectionData[0]['label']['ar'];

      print("Sections : ${_sectionText}");
      print("sub Sections : ${_subSectionText}");
      print("_getSections : END");
    });
  }

  bool deleteIcon = true;
  bool pauseIcon = true;
  bool editIcon = true;
  bool renewIcon = true;

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
    });
  }

  _getLang() async {
    SharedPreferences _pr = await SharedPreferences.getInstance();
    setState(() {
      lang = _pr.getString('lang');
    });
  }

  fetchAds({int hasImg}) {
    return PublicAdsServicesNew.getPublicAdsData(
            sectionId: widget.sectionId,
            subSectionId: widget.subSectionId,
            hasImage: hasImg,
            sort: sorting,
            txt: widget.txt,
            offset: offset.toString())
        .then((value) {
      setState(() {
        if (offset == 0) {
          _publicAd = value[0]['responseData']['ads'];
        } else {
          if (_publicAd.length > 0) {
            _num = value[0]['responseData']['ads'].length;
            setState(() {
              for (int index = 0; index < _num; index++) {
                _publicAd.add(value[0]['responseData']['ads'][index]);
              }
            });
          }
        }
        offset += 10;
        _loading = false;
        _getSections(sec: widget.sectionId, subSec: widget.subSectionId);
      });
    });
  }

  fetchAdsFilter() {
    return FilterAdsServices.getAdsData(
            filteredData: widget.filteredData, offset: offset)
        .then((value) {
      setState(() {
        if (offset == 0) {
          _publicAd = value[0]['responseData']['ads'];
        } else {
          if (_publicAd.length > 0) {
            _num = value[0]['responseData']['ads'].length;
            setState(() {
              for (int index = 0; index < _num; index++) {
                _publicAd.add(value[0]['responseData']['ads'][index]);
              }
            });
          }
        }
        offset += 10;
        _loading = false;
        _getSections(sec: widget.sectionId, subSec: widget.subSectionId);
      });
    });
  }

  fetchPrivateAds() {
    return MyAdsServicesNew.getMyAdsData(
            offset: offset.toString(), status: widget.actionTitle)
        .then((value) {
      setState(() {
        if (offset == 0) {
          _publicAd = value[0]['responseData']['ads'];
        } else {
          if (_publicAd.length > 0) {
            _num = value[0]['responseData']['ads'].length;
            setState(() {
              for (int index = 0; index < _num; index++) {
                _publicAd.add(value[0]['responseData']['ads'][index]);
              }
            });
          }
        }
        offset += 10;
        _loading = false;
      });
    });
  }

  fetchFavoriteAds() {
    return FavoriteAdsServices.getFavData(
      offset: offset.toString(),
    ).then((value) {
      setState(() {
        if (offset == 0) {
          _publicAd = value[0]['responseData']['ads'];
        } else {
          if (_publicAd.length > 0) {
            _num = value[0]['responseData']['ads'].length;
            setState(() {
              for (int index = 0; index < _num; index++) {
                _publicAd.add(value[0]['responseData']['ads'][index]);
              }
            });
          }
        }
        offset += 10;
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    _privateBool = widget.isPrivate ? true : false;
    _getLang();
    widget.isPrivate && (widget.txt == null || widget.txt == "")
        ? fetchPrivateAds()
        : widget.isFav && (widget.txt == null || widget.txt == "")
            ? fetchFavoriteAds()
            : (widget.isFilter)
                ? fetchAdsFilter()
                : fetchAds();
    widget.section = "section";
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.isPrivate
            ? fetchPrivateAds()
            : widget.isFav
                ? fetchFavoriteAds()
                : widget.isFilter
                    ? fetchAdsFilter()
                    : fetchAds(hasImg: isChecked ? 1 : 0);
        print('End of screen');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void toggleCheckbox(bool value) {
    if (isChecked == false) {
      fetchAds(hasImg: 1);
      setState(() {
        isChecked = true;
      });
    } else {
      fetchAds(hasImg: 0);
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      appBar: buildAppBar(centerTitle: true, bgColor: AppColors.whiteColor),
      body: _loading
          ? buildLoading(color: AppColors.redColor)
          : _publicAd.length == 0
              ? SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.blue.withOpacity(0.3),
                                    offset: Offset(2, 2),
                                    blurRadius: 1,
                                    spreadRadius: 2)
                              ]),
                          child: buildIconWithTxt(
                            label: Text(
                              "عذرا , لا يوجد اعلانات",
                              style:
                                  appStyle(color: AppColors.blue, fontSize: 22),
                            ),
                            iconColor: AppColors.blue,
                            iconData: !(widget.isFav && widget.fromHome)
                                ? Icons.arrow_back_outlined
                                : Icons.clear,
                            size: 30,
                            action: () {
                              if (widget.fromHome == true) {
                                return null;
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Stack(
                    children: [
                      if (!_privateBool &&
                          !widget.isFav &&
                          !widget.isFilter &&
                          !widget.fromHome)
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                color: AppColors.whiteColor,
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1,
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            offset = 0;
                                          });
                                          toggleCheckbox(value);
                                        },
                                        activeColor: Colors.green,
                                        checkColor: Colors.white,
                                        tristate: false,
                                      ),
                                    ),
                                    buildTxt(txt: _strController.withImages),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: AppColors.greyThree,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                color: AppColors.whiteColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.whiteColor,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: false,
                                        value: _chosenValue,
                                        style: TextStyle(color: Colors.black),
                                        items: <String>[
                                          _strController.oldToNew,
                                          _strController.newToOld,
                                          _strController.priceHighToLess,
                                          _strController.priceLessToHigh,
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                            offset = 0;
                                            _chosenValue = value;
                                            sorting = (_chosenValue ==
                                                    _strController.oldToNew)
                                                ? "oldToNew"
                                                : (_chosenValue ==
                                                        _strController.newToOld)
                                                    ? "newToOld"
                                                    : (_chosenValue ==
                                                            _strController
                                                                .priceLessToHigh)
                                                        ? "priceLessToHigh"
                                                        : "priceHighToLess";
                                            fetchAds(hasImg: isChecked ? 1 : 0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: !_privateBool &&
                                !widget.isFav &&
                                !widget.isFilter &&
                                !widget.fromHome
                            ? const EdgeInsets.only(top: 60)
                            : const EdgeInsets.only(top: 4),
                        child: _buildList(mq),
                      ),
                    ],
                  )),
    );
  }

  Container _buildList(MediaQueryData mq) {
    return Container(
      child: ListView.builder(
          controller: scrollController,
          itemCount: _publicAd.length+1,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == _publicAd.length) {
              return Container(height: mq.size.height*0.1,color: Colors.grey[200],child: CupertinoActivityIndicator());
            }
            int imgStatus = _publicAd[index]['count_of_images'] != null
                ? _publicAd[index]['count_of_images']
                : 0;
            var _data = _publicAd[index];

            return InkWell(
              onTap: () {
                print(_data['id'].toString());
                print(_data['slug']);
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      adID: _data['id'],
                      slug: _data['slug'],
                      isPrivate: _privateBool,
                    ),
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
                                          bgColor:
                                              AppColors.grey.withOpacity(0.1),
                                          size: 25,
                                          action: () {
                                            favoriteAd(
                                              scaffoldKey: _scaffoldKey,
                                              context: context,
                                              adId: _data['id'],
                                              state: _data['is_favorite_ad'] ==
                                                      true
                                                  ? "delete"
                                                  : "add",
                                            ).then((value) {
                                              setState(() {
                                                _data['is_favorite_ad'] =
                                                    !_data['is_favorite_ad'];
                                              });
                                              if (widget.isFav)
                                                _publicAd.remove(_data);
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
                              if (_data['created_at'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.descColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                                iconData:
                                                    FontAwesomeIcons.windows,
                                                size: 18,
                                              ),
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
                                                  "${TimeAgo.timeAgoSinceDate(_data['created_at'])}",
                                                  style: appStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.descColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                                iconData:
                                                    FontAwesomeIcons.clock,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (!_privateBool)
                                      if (_data['user_contact'] != null)
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              return Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdvertiserProfile(_data[
                                                                'user_contact']
                                                            ['hash_id']),
                                                  ));
                                            },
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: _data[
                                                                  'user_contact']
                                                              ['user_image'] !=
                                                          null
                                                      ? NetworkImage(
                                                          _data['user_contact']
                                                              ['user_image'])
                                                      : AssetImage(
                                                          "assets/images/user_img.png"),
                                                ),
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor:
                                                      _data['is_user_online']
                                                          ? AppColors.greenColor
                                                          : AppColors.grey,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                    style: appStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700),
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if ((_data['has_price'] &&
                                      _data['currency'] != null) &&
                                  _data['is_free'] == false &&
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
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              if (_data['is_free'])
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
                              if (_privateBool)
                                if (_data['status'] != 'deleted')
                                  buildUserSetting(_data, context, index),
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

  Column buildUserSetting(_data, BuildContext context, index) {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_data['status'] == 'expired')
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        child: Column(
                      children: [
                        buildIconButton(
                          icon: Icons.autorenew,
                          color: AppColors.blue,
                          onPressed: () {
                            reNewAd(context: context, adId: _data['id'])
                                .then((value) {
                              setState(() {
                                _data['status'] = 'edited';
                              });
                            });
                          },
                          size: 25,
                        ),
                        buildTxt(txt: "إعادة تفعيل")
                      ],
                    )),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: Column(
                      children: [
                        buildIconButton(
                          icon: _data['paused'] == true
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: _data['paused'] == true
                              ? AppColors.amberColor
                              : AppColors.greyFour,
                          onPressed: () {
                            setState(() {
                              pauseIcon = false;
                            });
                            pauseAd(
                              context: context,
                              adId: _data['id'],
                              pausedStatus: _data['paused'] == true ? 0 : 1,
                            ).then((value) {
                              setState(() {
                                pauseIcon = true;
                                _data['paused'] = !_data['paused'];
                              });
                            });
                          },
                          size: 25,
                        ),
                        buildTxt(
                            txt: _data['paused'] == true ? 'تشغيل' : 'إيقاف',
                            txtColor: _data['paused'] == true
                                ? AppColors.amberColor
                                : AppColors.greyFour)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                      child: Column(
                    children: [
                      buildIconButton(
                          icon: Icons.edit,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAdForm(
                                    fromEdit: true,
                                    sectionId: _data['section_id'].toString(),
                                    subSectionId: _data['sub_section_id'],
                                    adID: _data['id'],
                                  ),
                                ));
                          },
                          size: 25,
                          color: AppColors.blue),
                      buildTxt(txt: _strController.edit)
                    ],
                  )),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                      child: Column(
                    children: [
                      if (deleteIcon == true)
                        buildIconButton(
                          icon: Icons.delete,
                          color: AppColors.redColor,
                          size: 25,
                          onPressed: () {
                            buildDialog(
                                context: context,
                                title: _strController.deleteAd,
                                desc: _strController.askDeleteAd,
                                yes: _strController.ok,
                                no: _strController.cancel,
                                action: () {
                                  setState(() {
                                    deleteIcon = false;
                                  });
                                  deleteAd(
                                    context: context,
                                    adId: _data['id'],
                                  ).then((value) {
                                    setState(() {
                                      _data['status'] = 'deleted';
                                      deleteIcon = true;
                                    });
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                });
                          },
                        ),
                      if (!deleteIcon) CircularProgressIndicator(),
                      buildTxt(txt: "حذف")
                    ],
                  )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

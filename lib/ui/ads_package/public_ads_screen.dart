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
  bool multiList = false;

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
      appBar: widget.fromHome
          ? null
          : defaultAppbar(
              context,
              '${widget.actionTitle == 'approved' ? "${AppController.strings.postedAds}" : widget.actionTitle == 'rejected' ? '${AppController.strings.rejectedAds}' : widget.actionTitle == 'new' ? '${AppController.strings.waitingAds}' : widget.actionTitle == 'expired' ? '${AppController.strings.expiredAds}' : widget.isFav ? '${AppController.strings.myFav}' : '${AppController.strings.myAds}'}',
              leading: buildIconButton(
                  icon: multiList?FontAwesomeIcons.listAlt:FontAwesomeIcons.box,
                  size: 24,
                  color: AppColors.greenColor,
                  onPressed: () {
                    setState(() {
                      multiList = !multiList;
                    });
                  }),
            ),
      body: _loading
          ? buildLoading(color: AppColors.redColor)
          : _publicAd.length == 0
              ? SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Center(
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
                )
              : Directionality(
                  textDirection: _drController,
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
                        child: multiList
                            ? _buildList(mq)
                            : buildMultiListView(mq, scrollController),
                      ),
                    ],
                  ),
                ),
    );
  }

  _buildList(MediaQueryData mq) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: ListView.builder(
          controller: scrollController,
          itemCount: _publicAd.length + 1,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == _publicAd.length) {
              return Container(
                height: mq.size.height * 0.1,
                color: Colors.grey[200],
                child: CupertinoActivityIndicator(
                  radius: 15,
                ),
              );
            }
            int imgStatus = _publicAd[index]['count_of_images'] != null
                ? _publicAd[index]['count_of_images']
                : 0;
            var _data = _publicAd[index];

            return buildItemList(
                data: _data,
                context: context,
                mq: mq,
                imgStatus: imgStatus,
                privateBool: widget.isPrivate,
                userSetting: buildUserSetting(
                  isMulti: false,
                  data: _data,
                  context: context,
                  index: index,
                  pauseAds: () {
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
                  reNew: () => reNewAd(context: context, adId: _data['id'])
                      .then((value) {
                    setState(() {
                      _data['status'] = 'edited';
                    });
                  }),
                  deleteAds: () {
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
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  deleteIcon: deleteIcon,
                ),
                index: index,
                subSectionText: _subSectionText,
                favAction: () {
                  favoriteAd(
                    scaffoldKey: _scaffoldKey,
                    context: context,
                    adId: _data['id'],
                    state: _data['is_favorite_ad'] == true ? "delete" : "add",
                  ).then((value) {
                    setState(() {
                      _data['is_favorite_ad'] = !_data['is_favorite_ad'];
                    });
                    if (widget.isFav) _publicAd.remove(_data);
                  });
                });
          }),
    );
  }

  buildMultiListView(MediaQueryData mq, scrollController) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: _publicAd.length + 1,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == _publicAd.length) {
            return Container(
              height: mq.size.height * 0.1,
              color: Colors.grey[200],
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            );
          }
          var _data = _publicAd[index];

          // log("DATA : ${_data['images'][0]['image']}");
          bool hasImg = false;
          int imgStatus = _publicAd[index]['count_of_images'] != null
              ? _publicAd[index]['count_of_images']
              : 0;
          if (_data['images'] != [] || _data['images'] != null)
            hasImg = imgStatus > 0 ? true : false;
          // print(hasImg);

          return buildMultiCard(
              isPrivate: _privateBool,
              isFav: widget.isFav,
              scrollController: scrollController,
              adsData: _publicAd[index],
              hasImg: hasImg,
              mq: mq,
              data: _data,
              context: context,
              favAction: () {
                favoriteAd(
                  scaffoldKey: _scaffoldKey,
                  context: context,
                  adId: _data['id'],
                  state: _publicAd[index]['is_favorite_ad'] == true
                      ? "delete"
                      : "add",
                ).then((value) {
                  setState(() {
                    _publicAd[index]['is_favorite_ad'] =
                        !_publicAd[index]['is_favorite_ad'];
                    // LatestAdsServices.getLatestAdsData().then((value) {
                    //   setState(() {
                    //     _publicAd = value[0]['responseData'];
                    //     // log(_publicAd.toString());
                    //     // log('value $_publicAd');
                    //     // _loading = false;
                    //   });
                    // });
                  });
                });
              },
          userSetting: buildUserSetting(
            isMulti: true,
            data: _data,
            context: context,
            index: index,
            pauseAds: () {
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
            reNew: () => reNewAd(context: context, adId: _data['id'])
                .then((value) {
              setState(() {
                _data['status'] = 'edited';
              });
            }),
            deleteAds: () {
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
              Navigator.of(context, rootNavigator: true).pop();
            },
            deleteIcon: deleteIcon,
          ));
        },
      ),
    );
  }

  buildConvertList() {
    return Center(
      child: SizedBox(
        height: 30,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
      ),
    );
  }
}

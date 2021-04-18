import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_details_screen.dart';

class PrivateAdsListScreen extends StatefulWidget {
  final String actionTitle;

  PrivateAdsListScreen({@required this.actionTitle});

  @override
  _PrivateAdsListScreenState createState() => _PrivateAdsListScreenState();
}

class _PrivateAdsListScreenState extends State<PrivateAdsListScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;

  bool _loading = true;
  bool isList;
  List _privateAd;
  String _chosenValue;
  String lang;
  Color pausedColor = Colors.amber;
  Color unPausedColor = Colors.green;
  Color iconListColor;

  getLang() async {
    SharedPreferences _pr = await SharedPreferences.getInstance();
    setState(() {
      lang = _pr.getString('lang');
    });
  }

  @override
  void initState() {
    super.initState();
    getLang();
    setState(() {
      isList = true;
      iconListColor = AppColors.redColor;
    });
    print(widget.actionTitle);
    MyAdsServicesNew.getMyAdsData(
            offset: '', limit: '', status: widget.actionTitle)
        .then((value) {
      setState(() {
        _privateAd = value[0]['responseData']['ads'];
        print('ADS Length: ${_privateAd.length}');
        _loading = false;
      });
    });
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
          // appBar: buildAppBar(
          //     centerTitle: true,
          //     bgColor: AppColors.whiteColor,
          //     themeColor: Colors.grey),
          // drawer: buildDrawer(context),
          backgroundColor: Colors.grey.shade200,
          body: _loading
              ? buildLoading(color: AppColors.green)
              : _privateAd.length == 0
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(2, 2),
                                    blurRadius: 1,
                                    spreadRadius: 2)
                              ]),
                          child: buildIconWithTxt(
                            label: Text(
                              "No Data Found !",
                              style: appStyle(
                                  color: AppColors.whiteColor, fontSize: 26),
                            ),
                            iconColor: AppColors.whiteColor,
                            iconData: Icons.arrow_back_outlined,
                            size: 30,
                            action: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        buildBg(),
                        SingleChildScrollView(
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                buildFilter(),
                                SizedBox(
                                  height: 22,
                                ),
                                if (isList) buildListOneItem(mq),
                                if (isList == false) buildGridList(mq),
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

  Container buildListOneItem(MediaQueryData mq) {
    return Container(
      child: ListView.builder(
          itemCount: _privateAd.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int imgStatus = _privateAd[index]['count_of_images'];
            var _data = _privateAd[index];
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
                              if (_data['status'] == 'deleted')
                                Container(
                                  height: mq.size.height * 0.2,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/deleted.png"),
                                    ),
                                  ),
                                ),
                              if (_data['status'] != 'deleted')
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
                                            size: 30,
                                            action: () {
                                              favoriteAd(
                                                context: context,
                                                adId: _data['id'],
                                                state:
                                                    _data['is_favorite_ad'] ==
                                                            true
                                                        ? "delete"
                                                        : "add",
                                              ).then((value) {
                                                setState(() {
                                                  MyAdsServicesNew.getMyAdsData(
                                                          offset: '',
                                                          limit: '',
                                                          status: widget
                                                              .actionTitle)
                                                      .then((value) {
                                                    setState(() {
                                                      _privateAd = value[0]
                                                              ['responseData']
                                                          ['ads'];
                                                      //  print('ADS Length: ${_privateAd.length}');
                                                      _loading = false;
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
                                                      BorderRadius.circular(
                                                          16)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      myIcon(context,
                                                          Icons.video_call,
                                                          color: Colors.white,
                                                          size: 25,
                                                          hasDecoration: false),
                                                      buildTxt(
                                                          txt:
                                                              (_data['video'] ==
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
                              if (_data['status'] != 'deleted')
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            myIcon(context,
                                                FontAwesomeIcons.windows,
                                                color: Colors.black54,
                                                size: 25,
                                                hasDecoration: false),
                                            buildTxt(
                                                txt: (_data['section_id'])
                                                    .toString(),
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
                                                txt: _data['edited_at']
                                                    .toString(),
                                                txtColor: Colors.black54)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    _data['title'],
                                    // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                    style: appStyle(
                                        fontSize: 18,
                                        color: AppColors.blackColor2,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    _data['body'],
                                    // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                    style: appStyle(
                                        fontSize: 17,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (_data['has_price'] &&
                                  _data['currency'] != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,vertical: 12),
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      '${_data['price'].toString()}  ${_data['currency'][lang].toString()}',
                                      style: appStyle(
                                          fontSize: 18, color: AppColors.green),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              if (_data['status'] != 'deleted')
                                buildChoices(_data, index, context),
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

  Container buildGridList(MediaQueryData mq) {
    return Container(
      child: GridView.builder(
        itemCount: _privateAd.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          int imgStatus = _privateAd[index]['count_of_images'];
          var _data = _privateAd[index];
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
                                borderRadius: BorderRadius.circular(10),
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
                                        size: 30,
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
                                              MyAdsServicesNew.getMyAdsData(
                                                      offset: '',
                                                      limit: '',
                                                      status:
                                                          widget.actionTitle)
                                                  .then((value) {
                                                setState(() {
                                                  _privateAd = value[0]
                                                      ['responseData']['ads'];
                                                  //  print('ADS Length: ${_privateAd.length}');
                                                  _loading = false;
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
                                        width: mq.size.width * 0.24,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  _data['title'],
                                  // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                  style: appStyle(                                      fontSize: 18,
                                      color: AppColors.blackColor2,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  _data['body'],
                                  // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                                  style: appStyle(
                                      fontSize: 17,
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
                    ? 2
                    : 4,
            childAspectRatio: 0.7),
      ),
    );
  }

  Container buildFilter() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(5),
              height: 50,
              color: AppColors.whiteColor,
              child: Row(
                children: [
                  buildIcons(
                      iconData: FontAwesomeIcons.listUl,
                      color: isList ? iconListColor : AppColors.grey,
                      action: () {
                        setState(() {
                          isList = true;
                        });
                      }),
                  buildIcons(
                      iconData: FontAwesomeIcons.windows,
                      color: isList ? AppColors.grey : iconListColor,
                      action: () {
                        setState(() {
                          isList = false;
                        });
                      }),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.whiteColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.whiteColor,
                ),
                child: DropdownButton<String>(
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
                      child: Text(value,style:appStyle(fontSize: 14),),
                    );
                  }).toList(),
                  hint: Text(
                    _strController.orderBy,
                    style: appStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildChoices(var _data, int index, ctx) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: _data['paused'] == true
                                  ? Colors.amber
                                  : Colors.green)),
                      child: buildIconWithTxt(
                          label: Text(
                            "${_data['paused'] == true ? _strController.active : _strController.pausedAds}",
                            style: appStyle(fontSize: 14),
                          ),
                          iconData: _data['paused'] == true
                              ? Icons.play_arrow
                              : Icons.pause,
                          action: () {
                            pauseAd(
                              context: ctx,
                              adId: _data['id'],
                              pausedStatus: _data['paused'] == true ? 0 : 1,
                            ).then((value) {
                              setState(() {
                                // pausedColor == Colors.amber
                                //     ? pausedColor = Colors.green
                                //     : pausedColor = Colors.amber;
                                MyAdsServicesNew.getMyAdsData(
                                  offset: '',
                                  limit: '',
                                  status: widget.actionTitle,
                                ).then((value) {
                                  setState(() {
                                    if (widget.actionTitle == 'fav') {
                                      _privateAd = value[0]['responseData']['ads']
                                          .where((element) =>
                                      element['is_favorite_ad'] == true)
                                          .toList();
                                    } else {
                                      _privateAd = value[0]['responseData']['ads'];
                                    }
                                    _loading = false;
                                  });
                                });
                              });
                            });
                          },
                          size: 30,
                          iconColor: _data['paused'] ? pausedColor : unPausedColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.blue)),
                      child: buildIcons(
                        // label: Text(_strController.edit,style: appStyle(fontSize: 14),),
                          iconData: Icons.edit,
                          action: () {},
                          size: 30,
                          color: AppColors.blue),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: AppColors.redColor)),
                      child: buildIcons(
                          // label: Text(
                          //   _strController.deleteAd,
                          //     style:appStyle(fontSize: 14)
                          // ),
                          iconData: Icons.delete,
                          action: () {
                            buildDialog(
                                context: ctx,
                                title: _strController.deleteAd,
                                desc: _strController.askDeleteAd,
                                //alertType: AlertType.warning,
                                yes: _strController.ok,
                                no: _strController.cancel,
                                action: () {
                                  deleteAd(
                                    context: ctx,
                                    adId: _data['id'],
                                  ).then((value) {
                                    setState(() {
                                      MyAdsServicesNew.getMyAdsData(
                                        offset: '',
                                        limit: '',
                                        status: widget.actionTitle,
                                      ).then((value) {
                                        setState(() {
                                          _privateAd =
                                              value[0]['responseData']['ads'];

                                          _loading = false;
                                        });
                                      });
                                    });
                                  });

                                  Navigator.of(context, rootNavigator: true).pop();
                                });
                          },
                          size: 30,
                          color: AppColors.redColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_data['status'] == 'expired')
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: AppColors.blue)),
                        child: buildIconWithTxt(
                            label: Text("Renew"),
                            iconData: Icons.autorenew,
                            action: () {
                              reNewAd(context: ctx, adId: _data['id']).then((value) {
                                setState(() {
                                  MyAdsServicesNew.getMyAdsData(
                                    offset: '',
                                    limit: '',
                                    status: widget.actionTitle,
                                  ).then((value) {
                                    setState(() {
                                      _privateAd = value[0]['responseData']['ads'];
                                      _loading = false;
                                    });
                                  });
                                });
                              });
                            },
                            size: 30,
                            iconColor: AppColors.blue),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

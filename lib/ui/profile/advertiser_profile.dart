import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/details_screen.dart';
import 'package:kulshe/ui/ads_package/time_ago.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertiserProfile extends StatefulWidget {
  final String idHash;

  AdvertiserProfile(this.idHash);

  @override
  _AdvertiserProfileState createState() => _AdvertiserProfileState();
}

class _AdvertiserProfileState extends State<AdvertiserProfile> {
  bool _loading = false;
  bool isChecked;
  int offset = 0;
  int limit = 10;
  String countOfAds;
  double countOfPager;
  String sorting;
  String lang;
  List _publicAd;
  var _publicProfile;
  String _sectionText;
  String _subSectionText;
  List _sectionData;
  List _subSectionData;

  num _num = 0;
  ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _getLang() async {
    SharedPreferences _pr = await SharedPreferences.getInstance();
    setState(() {
      lang = _pr.getString('lang');
    });
  }

  _getSections({int sec, int subSec}) async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      // _sectionData =
      //     _sectionData.where((element) => element['id'] == sec).toList();
      // _sectionText = _sectionData[0]['label']['ar'];
      // _subSectionData = _sectionData[0]['sub_sections']
      //     .where((element) => (element['id'] == subSec))
      //     .toList();
      // _subSectionText = _subSectionData[0]['label']['ar'];
    });
  }

  fetchAds() {
    return AdvertiserProfileServices.advertiserProfile(
            limit: '$limit', offset: '$offset', idHash: widget.idHash)
        .then((value) {
      setState(() {
        print('${value[0]['responseData'].length}');
        if (offset == 0) {
          _publicAd = value[0]['responseData']['ads'];
          _publicProfile = value[0]['responseData'];
        } else {
          if (_publicProfile.length > 0) {
            _num = value[0]['responseData'].length;
            _publicProfile = value[0]['responseData'];
            setState(() {
              for (int index = 0; index < _num; index++) {
                // print('DATA $index   ${_publicAd[index]['id']}');
                _publicProfile.add(value[0]['responseData'][index]);
              }
            });
          }
        }
        offset += 10;
        _loading = false;
        _getSections(
            sec: _publicProfile['section_id'],
            subSec: _publicProfile['sub_section_id']);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    _getLang();
    fetchAds();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchAds();
        print('End of screen');
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final _strController = AppController.strings;
  final _dirController = AppController.textDirection;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
     return SafeArea(
      child: Scaffold(
         key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: _loading
            ? buildLoading(color: AppColors.redColor)
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    buildBg(),
                    _buildList(mq),
                  ],
                )),
        // Stack(
        //         children: [
        //           buildBg(),
        //           Directionality(
        //             textDirection: _dirController,
        //             child: Stack(
        //               children: [
        //                 Container(
        //                   child:
        //             // ListView(
        //             //         children: [
        //                       // Container(
        //                       //     decoration: BoxDecoration(
        //                       //         gradient: LinearGradient(
        //                       //             begin: Alignment.topCenter,
        //                       //             end: Alignment.bottomCenter,
        //                       //             colors: [Colors.deepOrange, Colors.pinkAccent]
        //                       //         )
        //                       //     ),
        //                       //     child: Container(
        //                       //       width: double.infinity,
        //                       //       height: 300.0,
        //                       //       child: Center(
        //                       //         child: Column(
        //                       //           crossAxisAlignment: CrossAxisAlignment.center,
        //                       //           mainAxisAlignment: MainAxisAlignment.center,
        //                       //           children: [
        //                       //             _publicProfile['profile_image']!=null?
        //                       //             CircleAvatar(
        //                       //               backgroundImage: NetworkImage(
        //                       //                 _publicProfile['profile_image'],
        //                       //               ),
        //                       //               radius: 50.0,
        //                       //             ):CircleAvatar(
        //                       //               backgroundImage: AssetImage(
        //                       //                 "assets/images/no_img.png",
        //                       //               ),
        //                       //               radius: 30.0,
        //                       //             ),
        //                       //             SizedBox(
        //                       //               height: 10.0,
        //                       //             ),
        //                       //             Text(
        //                       //               _publicProfile['full_name']!=null?_publicProfile['full_name']:"",
        //                       //               style: TextStyle(
        //                       //                 fontSize: 22.0,
        //                       //                 color: Colors.white,
        //                       //               ),
        //                       //             ),
        //                       //             SizedBox(
        //                       //               height: 10.0,
        //                       //             ),
        //                       //             Card(
        //                       //               margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
        //                       //               clipBehavior: Clip.antiAlias,
        //                       //               color: Colors.white,
        //                       //               elevation: 5.0,
        //                       //               child: Padding(
        //                       //                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
        //                       //                 child: Row(
        //                       //                   children: [
        //                       //                     Expanded(
        //                       //                       child: Column(
        //                       //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                       //                         children: [
        //                       //                           Text(
        //                       //                             _strController.ads,
        //                       //                             style: appStyle(
        //                       //                               color: Colors.redAccent,
        //                       //                               fontSize: 20.0,
        //                       //                               fontWeight: FontWeight.bold,
        //                       //                             ),
        //                       //                           ),
        //                       //                           SizedBox(
        //                       //                             height: 5.0,
        //                       //                           ),
        //                       //                           Text(
        //                       //                             _publicProfile['total'].toString() ,
        //                       //                             style: appStyle(
        //                       //                               fontSize: 20.0,
        //                       //                               color: Colors.pinkAccent,
        //                       //                             ),
        //                       //                           )
        //                       //                         ],
        //                       //                       ),
        //                       //                     ),
        //                       //                     Expanded(
        //                       //                       child: Column(
        //                       //
        //                       //                         children: [
        //                       //                           // Text(
        //                       //                           //   _publicProfile['email'],
        //                       //                           //   style: appStyle(
        //                       //                           //     color: Colors.redAccent,
        //                       //                           //     fontSize: 18.0,
        //                       //                           //     fontWeight: FontWeight.bold,
        //                       //                           //   ),
        //                       //                           // ),
        //                       //                           // SizedBox(
        //                       //                           //   height: 5.0,
        //                       //                           // ),
        //                       //                           InkWell(
        //                       //                             onTap: ()=>launch(
        //                       //                                 "tel://${'+'+_publicProfile['mobile_country_code']+_publicProfile['mobile_number'].toString()}"),
        //                       //                             child: CircleAvatar(
        //                       //                               backgroundColor: AppColors.grey.withOpacity(0.2),
        //                       //                               radius: 25,
        //                       //                               child: buildIconButton(icon: FontAwesomeIcons.phoneAlt,size: 24,color: AppColors.greenColor.withOpacity(0.5)),
        //                       //                             ),
        //                       //                           )
        //                       //
        //                       //                         ],
        //                       //                       ),
        //                       //                     ),
        //                       //                    ],
        //                       //                 ),
        //                       //               ),
        //                       //             )
        //                       //           ],
        //                       //         ),
        //                       //       ),
        //                       //     )
        //                       // ),
        //                       _buildList(mq)
        //                     // ],
        //                   // ),
        //                 ),
        //                 InkWell(child: Align(child: Container(width: 50,height: 50,child: Icon(Icons.arrow_back)),alignment: Alignment.topRight,),onTap: ()=>Navigator.of(context).pop(),)
        //
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
      ),
    );
  }

  Widget _buildList(MediaQueryData mq) {
    return _publicAd.length == 0?Container(
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
                      color: Colors.blue.withOpacity(0.3),
                      offset: Offset(2, 2),
                      blurRadius: 1,
                      spreadRadius: 2)
                ]),
            child: buildIconWithTxt(
              label: Text(
                "عذرا , لا يوجد اعلانات",
                style: appStyle(
                    color: AppColors.blue, fontSize: 22),
              ),
              iconColor: AppColors.blue,
              iconData: Icons.arrow_back_outlined,
              size: 30,
              action: () {
                  Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    ):
      Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //   Colors.deepOrange,
                  //   Colors.pinkAccent
                  // ])
                ),
                child: Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height*0.3,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: _publicProfile['profile_image'] != null
                                        ? NetworkImage(
                                        _publicProfile['profile_image'])
                                        : AssetImage(
                                        "assets/images/user_img.png"),
                                  ),
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: _publicProfile['is_user_online']?AppColors.greenColor:AppColors.grey,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                _publicProfile['nick_name'],
                                style: appStyle(
                                  fontSize: 22.0,
                                  color: AppColors.blackColor2,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              _strController.ads,
                                              style: appStyle(
                                                color: Colors.redAccent,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              _publicProfile['total']
                                                  .toString(),
                                              style: appStyle(
                                                fontSize: 20.0,
                                                color: Colors.pinkAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            // Text(
                                            //   _publicProfile['email'],
                                            //   style: appStyle(
                                            //     color: Colors.redAccent,
                                            //     fontSize: 18.0,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            // SizedBox(
                                            //   height: 5.0,
                                            // ),
                                            InkWell(
                                              onTap: () => launch(
                                                  "tel://${'+' + _publicProfile['mobile_country_code'] + _publicProfile['mobile_number'].toString()}"),
                                              child: CircleAvatar(
                                                backgroundColor: AppColors
                                                    .grey
                                                    .withOpacity(0.2),
                                                radius: 25,
                                                child: buildIconButton(
                                                    icon: FontAwesomeIcons
                                                        .phoneAlt,
                                                    size: 24,
                                                    color: AppColors
                                                        .greenColor
                                                        .withOpacity(0.5)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(textDirection: TextDirection.ltr,child: Align(alignment: Alignment.topLeft,child: IconButton(icon: Icon(Icons.arrow_back,color: AppColors.blackColor2,),onPressed: ()=>Navigator.pop(context),))),
                      ),
                    ],
                  ),
                )),
            Container(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: _publicAd.length+1,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == _publicAd.length) {
                      return Container(height: mq.size.height*0.1,color: Colors.grey[200],child: CupertinoActivityIndicator());
                    }


                    print('_publicAd: ${_publicAd[index]['count_of_images']}');
                    int imgStatus = _publicAd[index] != null
                        ? _publicAd[index]['count_of_images'] != null
                            ? _publicAd[index]['count_of_images']
                            : 0
                        : '';
                    var _data = _publicAd[index];
                    // print('AAAA ${_data['user_contact']}');
                    // _sectionData =
                    //     _sectionData.where((element) => element['id'] == _data['section_id']).toList();
                    // _subSectionData = _sectionData[index]['sub_sections']
                    //     .where((element) => (element['id'] == _data['sub_section_id']))
                    //     .toList();
                    // _subSectionText = _sectionData[0]['label'][lang??'ar'];

                    print('_sec:$_sectionData');
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
                              isPrivate: false,
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
                                                      // value == 1019 // add to fav
                                                      // value == 2136 // already fav
                                                      // value == 1020 // delete
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
                                                      // child: Text("$_sectionText",style: appStyle(fontSize: 15,fontWeight: FontWeight.w400),)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // child: SingleChildScrollView(
                                            //   scrollDirection: Axis.horizontal,
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.spaceEvenly,
                                            //     children: [
                                            //       Row(
                                            //         children: [
                                            //           myIcon(
                                            //               context, FontAwesomeIcons.windows,
                                            //               color: Colors.black54,
                                            //               size: 20,
                                            //               hasDecoration: false),
                                            //           buildTxt(
                                            //               txt: ("شقق للبيع للبيع للبيع للبيع للبيع للبيعااااااااااااااااااااااااااا").toString(),
                                            //               txtColor: Colors.black54)
                                            //         ],
                                            //       ),
                                            //       SizedBox(width: 50,),
                                            //       Row(
                                            //         children: [
                                            //           myIcon(context,
                                            //               Icons.access_time_outlined,
                                            //               color: Colors.black54,
                                            //               size: 22,
                                            //               hasDecoration: false),
                                            //           buildTxt(
                                            //               txt:
                                            //                   // widget.isFav?"":
                                            //                   TimeAgo.timeAgoSinceDate(
                                            //                       _data['created_at'])
                                            //               // (_data['created_at'])
                                            //               //     .toString()
                                            //               ,
                                            //               txtColor: Colors.black54)
                                            //         ],
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
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
                                            // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
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
                                      // if (_data['has_price']==flase && _data['price'] == 0)
                                      //   Text(""),

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
            ),
          ],
        ),
      ),
    );
  }
}

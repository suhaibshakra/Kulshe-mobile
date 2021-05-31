import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/search_ui.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';
import 'package:kulshe/ui/profile/advertiser_profile.dart';
import 'package:kulshe/ui/profile/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_screen.dart';

class LatestAds extends StatefulWidget {
  @override
  _LatestAdsState createState() => _LatestAdsState();
}

class _LatestAdsState extends State<LatestAds> {
  List _adsData;
  bool _loading = true;
  int offset = 0;
  bool isLargeList;
  bool multiList = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  num testVar = 0;

  fetchLatestAds() {
    return LatestAdsServices.getLatestAdsData(offset: offset).then((value) {
      setState(() {
        print('${value[0]['responseData'].length}');
        if (offset == 0) {
          _adsData = value[0]['responseData'];
        } else {
          if (_adsData.length > 0) {
            testVar = value[0]['responseData'].length;
            setState(() {
              for (int index = 0; index < testVar; index++) {
                print('DATA $index   ${_adsData[index]['id']}');
                _adsData.add(value[0]['responseData'][index]);
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
    super.initState();
    _getEmailVerified();
    fetchLatestAds();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchLatestAds();
        print('End of screen');
      }
    });
  }

  bool showDrop = false;
  var isEmailVerified = false;

  _getEmailVerified() async {
    SharedPreferences _getEmail = await SharedPreferences.getInstance();
    isEmailVerified = _getEmail.getBool('isEmailVerified');
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // appBar: buildAppBar(
      //     centerTitle: true,
      //     bgColor: AppColors.whiteColor,
      //     themeColor: Colors.grey),
      // drawer: buildDrawer(context),
      // backgroundColor: Colors.grey.shade200,

      endDrawer: buildDrawer(context, () => Navigator.of(context).pop()),
      body: _loading
          ? buildLoading(color: AppColors.redColor)
          : SafeArea(
              child: Stack(
                children: [
                  buildBg(),
                  NestedScrollView(
                    headerSliverBuilder: (context, innerBoxScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          foregroundColor: Colors.lightBlue,
                          shadowColor: Colors.red,
                          expandedHeight: isLandscape
                              ? mq.size.height * 0.3
                              : mq.size.height * 0.14,
                          pinned: true,
                          floating: false,
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                                  AssetImage('assets/images/logo_icon.png'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          leading: GestureDetector(
                              onTap: () => Scaffold.of(context).openEndDrawer(),
                              child: Icon(
                                Icons.list,
                                color: Colors.black54,
                              )),
                          actions: [
                            Container(
                              width: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                child: Badge(
                                  badgeColor: AppColors.redColor,
                                  badgeContent: Text(
                                    !isEmailVerified ? '1' : '',
                                    style: TextStyle(color: AppColors.whiteColor),
                                  ),
                                  child: Container(
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      onPressed: (){
                                        setState(() {
                                          showDrop = !showDrop;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.notifications,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(onPressed: () =>Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfileScreen(),)) , icon: Icon(Icons.account_circle,color: AppColors.grey,))
                            // buildIconButton(
                            //   icon: Icons.notifications,
                            //   color: Colors.black54,
                            //   size: 25,
                            //   onPressed: () {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //       builder: (context) => EditProfileScreen(),
                            //     //     ),
                            //     // );
                            //   },
                            // ),
                            // buildIconButton(
                            //   icon: Icons.account_circle_rounded,
                            //   color: Colors.black54,
                            //   size: 25,
                            //   onPressed: () {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //       builder: (context) => EditProfileScreen(),
                            //     //     ),
                            //     // );
                            //   },
                            // ),
                          ],
                          centerTitle: true,
                          backgroundColor: Colors.white,
                          toolbarHeight: 50,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/main_bg.png"),
                                      fit: BoxFit.cover)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 55,
                                ),
                                child: Directionality(
                                  textDirection: AppController.textDirection,
                                  child: SearchWidget(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        buildConvertList(),
                        if (multiList)
                          Expanded(
                            child: buildMultiListView(mq, scrollController),
                          )
                        else
                          Expanded(child: _buildList(mq)),
                      ],
                    ),
                  ),
                  if (showDrop)
                    Stack(
                      children: [
                        if (!isEmailVerified)
                          Container(
                            decoration:
                                BoxDecoration(color: AppColors.whiteColor),
                            width: double.infinity,
                            height: mq.size.height,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: ListView.separated(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: ListTile(
                                      title: Text(
                                        " لم يتم التحقق من بريدك الإلكتروني. لن يتم نشر إعلاناتك حتى يتم تفعيل البريد الإلكتروني الخاص بك. ",
                                        style: appStyle(
                                            color: index == 0
                                                ? Colors.amber
                                                : AppColors.blackColor2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: index == 0 || index == 1
                                          ? InkWell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                    onTap: () => verifyEmail(
                                                        context: context),
                                                    child: Text(
                                                      "أرسل رسالة التحقق مرة أخرى",
                                                      style: appStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.green,
                                                          fontSize: 20),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                              ),
                                            )
                                          : "",
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  showDrop = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.cancel,
                                  size: 26,
                                  color: AppColors.grey,
                                ),
                              )),
                        )
                      ],
                    ),
                ],
              ),
            ),
      // body:_loading?buildLoading(color: AppColors.grey): buildListView(isLandscape, context),
    );
  }

  // Widget build(BuildContext context) {
  //   final mq = MediaQuery.of(context);
  //   bool isLandscape =
  //       MediaQuery.of(context).orientation == Orientation.landscape;
  //   return SafeArea(
  //     child: Scaffold(
  //       endDrawer: buildDrawer(context, () {
  //         Navigator.of(context).pop();
  //       }),
  //       key: _scaffoldKey,
  //       resizeToAvoidBottomInset: false,
  //       body: _loading
  //           ? buildLoading(color: AppColors.redColor)
  //           : Directionality(
  //               textDirection: AppController.textDirection,
  //               child: Stack(
  //                 children: [
  //                   buildBg(),
  //                   NestedScrollView(
  //                     headerSliverBuilder: (context, innerBoxScrolled) {
  //                       return <Widget>[
  //                         SliverAppBar(
  //                           foregroundColor: Colors.lightBlue,
  //                           shadowColor: Colors.red,
  //                           expandedHeight: isLandscape
  //                               ? mq.size.height * 0.3
  //                               : mq.size.height * 0.14,
  //                           pinned: true,
  //                           floating: false,
  //                           title: Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 6, vertical: 6),
  //                             child: CircleAvatar(
  //                               radius: 20.0,
  //                               backgroundImage:
  //                                   AssetImage('assets/images/logo_icon.png'),
  //                               backgroundColor: Colors.transparent,
  //                             ),
  //                           ),
  //                           leading: InkWell(
  //                             onTap: () {
  //                               setState(() {
  //                                 // _showDrawer = true;
  //                                 Scaffold.of(context).openEndDrawer();
  //                               });
  //                             },
  //                             child: Icon(
  //                               Icons.list,
  //                               color: Colors.black54,
  //                             ),
  //                           ),
  //                           actions: [
  //                             buildIconButton(
  //                               icon: Icons.notifications,
  //                               color: Colors.black54,
  //                               size: 25,
  //                               onPressed: () {
  //                                 // Navigator.push(
  //                                 //     context,
  //                                 //     MaterialPageRoute(
  //                                 //       builder: (context) => EditProfileScreen(),
  //                                 //     ),
  //                                 // );
  //                               },
  //                             ),
  //                             buildIconButton(
  //                               icon: Icons.account_circle_rounded,
  //                               color: Colors.black54,
  //                               size: 25,
  //                               onPressed: () {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => EditProfileScreen(),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ],
  //                           centerTitle: true,
  //                           backgroundColor: Colors.white,
  //                           toolbarHeight: 50,
  //                           flexibleSpace: FlexibleSpaceBar(
  //                             background: Container(
  //                               decoration: BoxDecoration(
  //                                   shape: BoxShape.rectangle,
  //                                   image: DecorationImage(
  //                                       image: AssetImage(
  //                                           "assets/images/main_bg.png"),
  //                                       fit: BoxFit.cover)),
  //                               child: Padding(
  //                                   padding: const EdgeInsets.only(
  //                                     top: 55,
  //                                   ),
  //                                   child: SearchWidget()),
  //                             ),
  //                           ),
  //                         ),
  //                       ];
  //                     },
  //                     body: (multiList)?
  //                       buildMultiListView(mq, scrollController):
  //                     _buildList(mq),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //     ),
  //   );
  // }

  buildMultiListView(MediaQueryData mq, scrollController) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: _adsData.length + 1,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == _adsData.length) {
            return Container(
              height: mq.size.height * 0.1,
              color: Colors.grey[200],
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            );
          }
          var _data = _adsData[index];
          // log("DATA : ${_data['user_contact']['hash_id']}");
          bool hasImg = false;
          if (_data['images'] != [] || _data['images'] != null) hasImg = true;
          // print(hasImg);

          return buildMultiCard(
              isPrivate: false,
              isFav: false,
              adsData: _adsData[index],
              hasImg: hasImg,
              mq: mq,
              data: _data,
              context: context,
              favAction: () {
                favoriteAd(
                  scaffoldKey: _scaffoldKey,
                  context: context,
                  adId: _data['id'],
                  state: _adsData[index]['is_favorite_ad'] == true
                      ? "delete"
                      : "add",
                ).then((value) {
                  setState(() {
                    _adsData[index]['is_favorite_ad'] =
                        !_adsData[index]['is_favorite_ad'];
                    // LatestAdsServices.getLatestAdsData().then((value) {
                    //   setState(() {
                    //     _adsData = value[0]['responseData'];
                    //     // log(_adsData.toString());
                    //     // log('value $_adsData');
                    //     // _loading = false;
                    //   });
                    // });
                  });
                });
              });
        },
      ),
    );
  }

  _buildList(MediaQueryData mq) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: Container(
        child: ListView.builder(
            controller: scrollController,
            itemCount: _adsData.length + 1,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == _adsData.length) {
                return Container(
                  height: mq.size.height * 0.1,
                  color: Colors.grey[200],
                  child: CupertinoActivityIndicator(
                    radius: 15,
                  ),
                );
              }
              int imgStatus = _adsData[index]['count_of_images'] != null
                  ? _adsData[index]['count_of_images']
                  : 0;
              var _data = _adsData[index];

              return buildItemList(
                  data: _data,
                  context: context,
                  mq: mq,
                  imgStatus: imgStatus,
                  privateBool: false,
                  index: index,
                  subSectionText: 'null',
                  favAction: () {
                    favoriteAd(
                      scaffoldKey: _scaffoldKey,
                      context: context,
                      adId: _data['id'],
                      state: _adsData[index]['is_favorite_ad'] == true
                          ? "delete"
                          : "add",
                    ).then((value) {
                      setState(() {
                        _adsData[index]['is_favorite_ad'] =
                            !_adsData[index]['is_favorite_ad'];
                      });
                    });
                  });
            }),
      ),
    );
  }

  buildConvertList() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildIconButton(
                icon: multiList?FontAwesomeIcons.listAlt:FontAwesomeIcons.box,
                size: 24,
                color: multiList ? AppColors.redColor : AppColors.grey,
                onPressed: () {
                  setState(() {
                    multiList = !multiList;
                  });
                }),
            Padding(
              padding: EdgeInsets.all(8),
              child: buildTxt(
                txt: 'إعلانات مختارة',
                txtColor: AppColors.blackColor2,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}

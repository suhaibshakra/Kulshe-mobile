import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/search_ui.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';
import 'package:kulshe/ui/profile/advertiser_profile.dart';

import 'ad_details_screen.dart';

class LatestAds extends StatefulWidget {
  @override
  _LatestAdsState createState() => _LatestAdsState();
}

class _LatestAdsState extends State<LatestAds> {
  List _adsData;
  bool _loading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    LatestAdsServices.getLatestAdsData(iso: "JO").then((value) {
      setState(() {
        _adsData = value[0]['responseData'];
        log('value $_adsData');
        _loading = false;

        // print('Length ${_adsData.length}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: _loading
            ? buildLoading(color: AppColors.redColor)
            : Directionality(
          textDirection: AppController.textDirection,
             child:Stack(
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
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                           child: CircleAvatar(
                             radius: 30.0,
                             backgroundImage: AssetImage('assets/images/logo_icon.png'),
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
                           buildIconButton(
                             icon: Icons.notifications,
                             color: Colors.black54,
                             size: 25,
                             onPressed: () {
                               // Navigator.push(
                               //     context,
                               //     MaterialPageRoute(
                               //       builder: (context) => EditProfileScreen(),
                               //     ),
                               // );
                             },
                           ),
                           buildIconButton(
                             icon: Icons.account_circle_rounded,
                             color: Colors.black54,
                             size: 25,
                             onPressed: () {
                               // Navigator.push(
                               //     context,
                               //     MaterialPageRoute(
                               //       builder: (context) => EditProfileScreen(),
                               //     ),
                               // );
                             },
                           ),
                         ],
                         centerTitle: true,
                         backgroundColor: Colors.white,
                         toolbarHeight: 50,
                         flexibleSpace: FlexibleSpaceBar(
                           background: Container(
                             decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 image: DecorationImage(
                                     image: AssetImage("assets/images/main_bg.png"), fit: BoxFit.cover)),
                             child: Padding(
                                 padding: const EdgeInsets.only(
                                   top: 55,),
                                 child: SearchWidget(
                                   onSubmit: (String val) {
                                     if(val.isNotEmpty)
                                       Navigator.push(context,MaterialPageRoute(builder: (context) => PublicAdsListScreen(isFav: false,isFilter: false,isMain: false,txt: val,),));
                                     print('DONE ...');
                                     print('val:$val');
                                   },
                                 )
                             ),
                             // decoration: BoxDecoration(
                             //   borderRadius: BorderRadius.circular(8),
                             //     boxShadow: [
                             //       BoxShadow(
                             //           color: AppColors.grey,
                             //           spreadRadius: 1,
                             //           blurRadius: 1,
                             //           offset: Offset(1, 1)),
                             //     ],
                             //     // image: DecorationImage(image: NetworkImage(_profileData.profileImage)),
                             //     // gradient: LinearGradient(
                             //     //   colors: [
                             //     //     Colors.lightBlueAccent.shade400,
                             //     //     Colors.lightBlueAccent.shade200,
                             //     //     Colors.blue.shade200,
                             //     //     Colors.lightBlue.shade200,
                             //     //     Colors.lightBlueAccent.shade400,
                             //     //   ],
                             //     // ),
                             // ),
                           ),
                         ),
                       ),
                     ];
                   },
                   body: Padding(
                       padding:
                       const EdgeInsets.only(top: 5,),
                       child: buildListView(mq)),
                 ),
               ],
             ),
        ),
      ),
    );
  }

  ListView buildListView(MediaQueryData mq) {
     return ListView.builder(
        shrinkWrap: true,
        itemCount: _adsData.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var _data = _adsData[index];
          bool hasImg = false;
          if (_data['images'] != [] || _data['images'] != null) hasImg = true;
          print(hasImg);
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.only(bottom: 5.0),
            child: Stack(
              children: [

                InkWell(
                  onTap: () {
                    print(_data['id'].toString());
                    print(_data['slug']);
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdDetailsScreen(
                            adID: _data['id'], slug: _data['slug']),),);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        // Hero(
                        //   tag: '${item.newsTitle}',
                        if (hasImg)
                          Stack(
                            children: [
                              Container(
                                width: mq.size.width*0.4,
                                height: mq.size.height*0.19,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_data['images'][0]['image']),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              Container(
                                     height: mq.size.height*0.18,
                                width: mq.size.width*0.4,
                                  alignment: Alignment.center,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.32,
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
                                ),
                            ],
                          ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_data['show_contact'] != false)
                                InkWell(
                                  onTap: (){

                                    return Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertiserProfile('zoJyY'),));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: _data['user_contact']
                                        ['user_image'] !=
                                            null
                                            ? NetworkImage(_data['user_contact']
                                        ['user_image'])
                                            : AssetImage(
                                            "assets/images/no_img.png"),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        _data['user_contact']['nick_name'],
                                        style: appStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(
                                height: 10.0,
                              ),

                              Text(
                                _data['title'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: appStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                _data['body'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: appStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
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
                          scaffoldKey: _scaffoldKey,
                          context: context,
                          adId: _data['id'],
                          state:
                          _data['is_favorite_ad'] == true
                              ? "delete"
                              : "add",
                        ).then((value) {
                          setState(() {
                            LatestAdsServices.getLatestAdsData(iso: "JO").then((value) {
                              setState(() {
                                _adsData = value[0]['responseData'];
                                log('value $_adsData');
                                _loading = false;
                              });
                            });
                          });
                        });
                      }),
                ),

              ],
            ),
          );
        },
      );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/search_ui.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';

import 'ad_details_screen.dart';

class LatestAds extends StatefulWidget {
  @override
  _LatestAdsState createState() => _LatestAdsState();
}

class _LatestAdsState extends State<LatestAds> {
  List _adsData;

  @override
  void initState() {
    LatestAdsServices.getLatestAdsData(iso: "JO").then((value) {
      setState(() {
        _adsData = value[0]['responseData'];
        log('value $_adsData');
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
         body: Directionality(
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
                       child: buildListView()),
                 ),
               ],
             ),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _adsData.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var _data = _adsData[index];
          bool hasImg = false;
          if (_data['images'] != [] || _data['images'] != null) hasImg = true;
          print(hasImg);
          return InkWell(
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
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.only(bottom: 5.0),
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
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(_data['images'][0]['image']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ],
                      ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _data['title'],
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
                            maxLines: 3,
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
          );
        },
      );
  }

}

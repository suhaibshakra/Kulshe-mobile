import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/services.dart';
import '../../showImg.dart';

class UserPanel extends StatefulWidget {
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;

  bool _loading = true;
  List<Widget> listOfAdsTypes = [];

  var _profileData;

  @override
  void initState() {
    ProfileServicesNew.getProfileData()
        .then((value) {
      setState(() {
        _profileData = value[0]['responseData'];
        _buildList();
        _loading = false;
      });
    });
    super.initState();
  }
  _buildList(){
    setState(() {
      listOfAdsTypes = [
        listItem(
            context,
            LinearGradient(colors: [
              Colors.blueGrey.shade400,
              Colors.blueGrey.shade200,
              Colors.blueGrey.shade200,
              Colors.blueGrey.shade200,
              Colors.blueGrey.shade400,
            ]),
            AppColors.whiteColor,
            _strController.myAds,
            _profileData['ads_summary']['all_ads_count'],
            null,
            null,
            actionTitle: ""),
        listItem(
            context,
            LinearGradient(colors: [
              Colors.red.shade400,
              Colors.red.shade200,
              Colors.red.shade200,
              Colors.red.shade200,
              Colors.red.shade400,
            ]),
            AppColors.whiteColor,
            _strController.myFavAds,
            _profileData['ads_summary']['favorite_ads_count'],
            null,
            null,
            actionTitle: "fav",hasList:true),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.greenAccent.shade400,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade400,
          ]),
          AppColors.whiteColor,
          _strController.postedAds,
          _profileData['ads_summary']['approved_ads_count'],
          null,
          null,
          actionTitle: "approved",
        ),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.lightBlueAccent.shade400,
            Colors.lightBlueAccent.shade200,
            Colors.lightBlueAccent.shade200,
            Colors.lightBlueAccent.shade200,
            Colors.lightBlueAccent.shade400,
          ]),
          AppColors.whiteColor,
          _strController.waitingAds,
          _profileData['ads_summary']['waiting_approval_ads_count'],

          null,
          null,
          actionTitle: "new",
        ),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.orange.shade400,
            Colors.orange.shade300,
            Colors.orange.shade200,
            Colors.orange.shade300,
            Colors.orange.shade400,
          ]),
          AppColors.whiteColor,
          _strController.pausedAds,
          _profileData['ads_summary']['paused_ads_count'],
          null,
          null,
          actionTitle: "paused",
        ),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade200,
            Colors.blueGrey.shade200,
            Colors.blueGrey.shade200,
            Colors.blueGrey.shade400,
          ]),
          AppColors.whiteColor,
          _strController.expiredAds,
          _profileData['ads_summary']['expired_ads_count'],
          null,
          null,
          actionTitle: "expired",
        ),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.redAccent.shade400,
            Colors.redAccent.shade200,
            Colors.redAccent.shade200,
            Colors.redAccent.shade200,
            Colors.redAccent.shade400,
          ]),
          AppColors.whiteColor,
          _strController.rejectedAds,
          _profileData['ads_summary']['rejected_ads_count'],
          null,
          null,
          actionTitle: "rejected",
        ),
        listItem(
            context,
            LinearGradient(colors: [
              Colors.pinkAccent.shade400,
              Colors.pinkAccent.shade200,
              Colors.pinkAccent.shade200,
              Colors.pinkAccent.shade200,
              Colors.pinkAccent.shade400,
            ]),
            AppColors.whiteColor,
            _strController.deletedAds,
            _profileData['ads_summary']['deleted_ads_count'],
            null,
            null,
            actionTitle: "deleted",hasList: false),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(centerTitle: true,bgColor: AppColors.whiteColor),
        body: _loading || listOfAdsTypes == null ?buildLoading(color: AppColors.redColor):Stack(
          children: [
            buildBg(),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) {
                return <Widget>[
                  SliverAppBar(
                    foregroundColor: Colors.lightBlue,
                    shadowColor: Colors.red,
                    expandedHeight: isLandscape ?mq.size.height*0.1:mq.size.height*0.2,
                    automaticallyImplyLeading: false,
                    floating: false,
                     centerTitle: false,
                    backgroundColor: Colors.white,
                    toolbarHeight: 30,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_profileData['nick_name'],style: appStyle(color: AppColors.whiteColor,fontSize: 24,fontWeight: FontWeight.w700),),
                                  SizedBox(height: 5,),
                                  Text(_profileData['email'],style: appStyle(color: AppColors.whiteColor,fontSize: 18,fontWeight: FontWeight.w500),),
                                ],
                              ),
                              // InkWell(
                                // onTap:()=>Navigator.push(context,MaterialPageRoute(builder: (context) => ShowFullImage(img: _profileData['profile_image'],),)),
                                // child:
                                CircleAvatar(
                                  radius: 40.0,
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(image: NetworkImage("${_profileData['profile_image']}"),fit: BoxFit.cover)),),
                                  backgroundColor: Colors.transparent,
                                // ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(1, 1)),
                            ],
                            // image: DecorationImage(image: NetworkImage(_profileData.profileImage)),
                             ),
                      ),
                    ),
                  ),
                ];
              },
              body: Directionality(
                textDirection: _drController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                  child: GridView.count(
                    childAspectRatio: isLandscape ? 3 : 1.4,
                    children: listOfAdsTypes,
                    shrinkWrap: true,
                    crossAxisCount: isLandscape ? 3 : 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
   }
}
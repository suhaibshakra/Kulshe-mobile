import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/models/profile.dart';
import 'package:kulshe/services_api/services.dart';

import '../edit_profile_screen.dart';

class UserPanel extends StatefulWidget {
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;

  bool _loading = true;
  List<Widget> listOfAdsTypes = [];

  ResponseProfileData _profileData;

  @override
  void initState() {
      ProfileServices.getProfileData().then((profileData) {
        setState(() {
          _profileData = profileData[0].responseData;
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
            _strController.myAds,
            _profileData.adsSummary.allAdsCount,
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
            _strController.myFavAds,
            _profileData.adsSummary.favoriteAdsCount,
            null,
            null,
            actionTitle: "fav",hasList:false),
        listItem(
          context,
          LinearGradient(colors: [
            Colors.greenAccent.shade400,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade200,
            Colors.greenAccent.shade400,
          ]),
          _strController.postedAds,
          _profileData.adsSummary.approvedAdsCount,
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
          _strController.waitingAds,
          _profileData.adsSummary.waitingApprovalAdsCount,
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
          _strController.pausedAds,
          _profileData.adsSummary.pausedAdsCount,
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
          _strController.expiredAds,
          _profileData.adsSummary.expiredAdsCount,
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
          _strController.rejectedAds,
          _profileData.adsSummary.rejectedAdsCount,
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
            _strController.deletedAds,
            _profileData.adsSummary.deletedAdsCount,
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
    return Directionality(
      textDirection: _drController,
      child: SafeArea(
        child: Scaffold(
          body: _loading || listOfAdsTypes == null ?buildLoading(color: AppColors.green):Stack(
            children: [
              buildBg(),
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      foregroundColor: Colors.lightBlue,
                      shadowColor: Colors.red,
                      expandedHeight: isLandscape ?mq.size.height*0.3:mq.size.height*0.2,
                      pinned: true,
                      floating: false,
                      title: Text(_strController.userPanel,style: appStyle(color: AppColors.blackColor2,fontSize: 18),),
                       actions: [ buildIconButton(icon: Icons.edit,color: AppColors.blackColor2,size: 26,onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
                      }, ),

                      ],
                       centerTitle: false,
                      backgroundColor: Colors.white,
                      toolbarHeight: 50,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(thickness: 1,color: AppColors.blue,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(_profileData.nickName,style: appStyle(color: AppColors.whiteColor,fontSize: 24,fontWeight: FontWeight.w700),),
                                        SizedBox(height: 5,),
                                        Text(_profileData.email,style: appStyle(color: AppColors.whiteColor,fontSize: 18,fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 40.0,
                                      child: Container(
                                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(image: NetworkImage("${_profileData.profileImage}"),fit: BoxFit.cover)),),
                                      backgroundColor: Colors.transparent,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(1, 1)),
                              ],
                              // image: DecorationImage(image: NetworkImage(_profileData.profileImage)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightBlueAccent.shade400,
                                  Colors.lightBlueAccent.shade200,
                                  Colors.blue.shade200,
                                  Colors.lightBlue.shade200,
                                  Colors.lightBlueAccent.shade400,
                                ],
                              )),
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                  child: GridView.count(
                    childAspectRatio: isLandscape ? 3 : 1.4,
                    children: listOfAdsTypes,
                    shrinkWrap: true,
                    crossAxisCount: isLandscape ? 3 : 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
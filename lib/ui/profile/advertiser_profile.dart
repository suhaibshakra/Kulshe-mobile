import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:kulshe/ui/ads_package/ad_details_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _getLang() async {
    SharedPreferences _pr = await SharedPreferences.getInstance();
    setState(() {
      lang = _pr.getString('lang');
    });
  }

  @override
  void initState() {
    _loading = true;
    _getLang();
    AdvertiserProfileServices.advertiserProfile(limit: '$limit', offset: '$offset',idHash: widget.idHash)
        .then((value) {
      setState(() {
        _publicAd = value[0]['responseData']['ads'];
        _publicProfile = value[0]['responseData'];
        countOfAds = (value[0]['responseData']['total']).toString();
        print('count of ads : ${countOfAds.toString()}');
        countOfPager = (double.parse(countOfAds) / 10);
        countOfPager = countOfPager.ceil().toDouble();
        _loading = false;
        print('value : $_publicProfile');
      });
    });
    setState(() {
      isChecked = false;
    });
    super.initState();
  }

  final _strController = AppController.strings;
  final _dirController = AppController.textDirection;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Directionality(
        textDirection: _dirController,
        child: Scaffold(
          key: _scaffoldKey,
           resizeToAvoidBottomInset: false,
          body: _loading
              ? buildLoading(color: AppColors.green)
              : Stack(
                  children: [
                    buildBg(),
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Colors.deepOrange, Colors.pinkAccent]
                                        )
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 300.0,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                _publicProfile['profile_image'],
                                              ),
                                              radius: 50.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              _publicProfile['full_name'],
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Card(
                                              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                              clipBehavior: Clip.antiAlias,
                                              color: Colors.white,
                                              elevation: 5.0,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                            _publicProfile['total'].toString() ,
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
                                                          Text(
                                                            _publicProfile['email'],
                                                            style: appStyle(
                                                              color: Colors.redAccent,
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          InkWell(
                                                            onTap: ()=>launch(
                                                                "tel://${'+'+_publicProfile['mobile_country_code']+_publicProfile['mobile_number'].toString()}"),
                                                            child: CircleAvatar(
                                                              backgroundColor: AppColors.greyTwo,
                                                              radius: 25,
                                                              child: buildIconButton(icon: FontAwesomeIcons.phoneAlt,size: 24,color: AppColors.greenColor.withOpacity(0.3)),
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
                                    )
                                ),
                                buildListOneItem(mq),
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
                          InkWell(child: Align(child: Container(width: 50,height: 50,child: Icon(Icons.arrow_back)),alignment: Alignment.topRight,),onTap: ()=>Navigator.of(context).pop(),)

                        ],
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
          itemCount: _publicAd.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int imgStatus = _publicAd[index]['count_of_images'] != null
                ? _publicAd[index]['count_of_images']
                : 0;
            var _data = _publicAd[index];
            print("DATA:${_publicProfile['profile_image']}");
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
                                              scaffoldKey: _scaffoldKey,
                                              context: context,
                                              adId: _data['id'],
                                              state: _data['is_favorite_ad'] ==
                                                      true
                                                  ? "delete"
                                                  : "add",
                                            ).then((value) {
                                              setState(() {
                                                AdvertiserProfileServices
                                                        .advertiserProfile(
                                                            offset: '$offset',
                                                            limit: '$limit')
                                                    .then((value) {
                                                  setState(() {
                                                    _publicProfile = value[0]['responseData'];
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
                                              txt: "category".toString(),
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
                                      maxLines: 3,
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
    );
  }

  goToPrevious() {
    setState(() {
      _loading = true;
      AdvertiserProfileServices.advertiserProfile(
              offset: '${offset >= 10 && offset != 0 ? offset -= 10 : offset}',
              limit: '$limit')
          .then((value) {
        setState(() {
          _publicProfile = value[0]['responseData'];
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
      AdvertiserProfileServices.advertiserProfile(
              offset:
                  '${int.parse(countOfAds) > (offset + 10) ? offset += 10 : offset}',
              limit: '$limit')
          .then((value) {
        setState(() {
          _publicProfile = value[0]['responseData'];
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

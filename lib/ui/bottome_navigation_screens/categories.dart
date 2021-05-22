import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/search_ui.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';
import 'package:kulshe/ui/ads_package/public_ads_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  AnimationController _controller;
  Animation<double> _animation;
  bool upDown = true;
  List _sectionData;
  bool _loading = true;
  String lang;
  List _countryData;
  int selected = -1;

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    setState(() {
      _countryData = countries[0]['responseData'];
      lang = _gp.getString('lang');
    });
    // print(sections[0].responseData[4].name);
  }

  _getSections() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    setState(() {
      _sectionData = sections[0]['responseData'];
      _loading = false;
    });
    // print(sections[0].responseData[4].name);
  }

  var isEmailVerified = false;

  _getEmailVerified() async {
    SharedPreferences _getEmail = await SharedPreferences.getInstance();
    isEmailVerified = _getEmail.getBool('isEmailVerified');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('LANG:$lang');
    _getCountries();
    _getSections();
    _getEmailVerified();
    // CountriesServices.getCountries().then((countriesList) {
    //   setState(() {
    //     _countryData = countriesList[0].responseData;
    //     print('countries data : ${_countryData[0].name}');
    //   });
    // });
    // SectionServices.getSections().then((value) {
    //   setState(() {
    //     _sectionData = value[0].responseData;
    //     _loading = false;
    //   });
    // });
  }

  bool showDrop = false;

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
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Badge(
                                badgeColor: Colors.amber,
                                badgeContent: Text(
                                  !isEmailVerified ? '1' : '',
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                                child: InkWell(
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.grey,
                                    size: 28,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDrop = !showDrop;
                                    });
                                    // verifyEmail(context: context);
                                  },
                                ),
                              ),
                            ),
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
                                      textDirection: _drController,
                                      child: SearchWidget(),

                                  )),
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
                    body: Center(
                      key: Key('builder ${selected.toString()}'),
                      child: Directionality(
                        textDirection: _drController,
                        child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: buildListView(isLandscape, context)),
                      ),
                    ),
                  ),
                  if (showDrop)
                    Stack(
                      children: [
                        if(!isEmailVerified)
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
                                              " لم يتم التحقق من بريدك الإلكتروني. لن يتم نشر إعلاناتك حتى يتم تفعيل البريد الإلكتروني الخاص بك. ",style: appStyle(color:index == 0? Colors.amber: AppColors.blackColor2,fontWeight: FontWeight.bold),),
                                          subtitle: index == 0||index == 1?InkWell(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: ()=>verifyEmail(context: context),
                                                child: Text("أرسل رسالة التحقق مرة أخرى",style: appStyle(fontWeight: FontWeight.bold,color: AppColors.green,fontSize: 20),textAlign: TextAlign.center,)),
                                          ),):"",
                                        ),
                                      );
                                    }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
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

  ListView buildListView(bool isLandscape, BuildContext context) {
    return ListView.builder(
      itemCount: _sectionData.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, index) {
        var _data = _sectionData[index];
        var _subSections = _sectionData[index]['sub_sections'] as List;
        // print(_data['icon']);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              key: Key(index.toString()),
              backgroundColor: AppColors.whiteColor,
              initiallyExpanded: index==selected,
              onExpansionChanged: (expanded){
                if(expanded)
                  setState(() {
                    selected = index;
                  });
                else setState(() {
                  selected = -1;
                });
              },
              title: Text(
                _data['label'][lang ?? 'ar'],
                style: appStyle(
                  fontSize: 18,
                  color: AppColors.blackColor2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                  width: 35,
                  height: 35,
                  child:
                      // _data[index]['icon']!=null?
                      SvgPicture.network(
                    // _data['icon']!=null?_data['icon']:
                    "https://svgsilh.com/svg/1298734.svg", fit: BoxFit.fill,
                  )
//                     :SvgPicture.string(
//                     ''' <svg style="width:24px;height:24px" viewBox="0 0 24 24">
//   <path fill="#000" d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z" />
// </svg> ''',color: AppColors.grey),
                  ),
              children: [
                GridView.count(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  crossAxisCount: isLandscape ? 5 : 3,
                  childAspectRatio: (3 / 1.6),
                  children: _subSections
                      .map(
                        (data) => GestureDetector(
                          onTap: () {
                            // print(data.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PublicAdsScreen(
                                  sectionId: _data['id'],
                                  section: _data['label'][lang],
                                  subSectionId: data['id'],
                                  subSection: data['label'][lang],
                                  txt: "",
                                  isFav: false,
                                  isFilter: false,
                                  isMain: false,
                                  isPrivate: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(data['label'][lang].toString(),
                                  style: appStyle(
                                    fontSize: 15,
                                    color: AppColors.blackColor2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDropDown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.brown, width: 1.0)),
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  value: null,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.brown,
                  ),
                  iconSize: 40,
                  underline: Container(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  // onChanged: (String val) => setState(() => selection = val),
                  items: sampleList.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                          child: Text(option),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 1)))),
                    );
                  }).toList(),
                  selectedItemBuilder: (con) {
                    return sampleList.map((m) {
                      return Text(
                        m,
                      );
                    }).toList();
                  }),
            ),
          )),
    );
  }

  List sampleList = ["","ramadan", "ramadan 2", "ramadan 3"];
  var selection = "";
}

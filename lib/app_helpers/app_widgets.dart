import 'dart:convert';

import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/ui/about_pages/about_screen.dart';
import 'package:kulshe/ui/ads_package/add_ad/add_ad_sections.dart';
import 'package:kulshe/ui/ads_package/public_ads_screen.dart';
import 'package:kulshe/ui/ads_package/user_panel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_helpers/app_controller.dart';
import '../services_api/api.dart';
import '../ui/profile/edit_profile_screen.dart';
import 'package:toast/toast.dart';

import 'app_colors.dart';

final _strController = AppController.strings;

TextStyle appStyle({double fontSize,Color color,FontWeight fontWeight,TextDecoration decoration}){
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    fontFamily: 'Tajawal',
    decoration: decoration
  );
}

buildAppBar({
  Color themeColor,
  Color bgColor,
  bool centerTitle,
}) {
  return AppBar(
    iconTheme: IconThemeData(color: themeColor),
    backgroundColor: bgColor,
    centerTitle: centerTitle,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Hero(
        tag: 'logo',
        child: CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('assets/images/logo_icon.png'),
          backgroundColor: Colors.transparent,
        ),
      ),
    ),
  );
}
GlobalKey<ProgressHudState> _hudKey = GlobalKey();

buildDrawer(BuildContext context, Function action, {fromNav = false}) {
  return ProgressHud(
     isGlobalHud: true,
    child: LayoutBuilder(
      builder: (ctx, constraints) => Container(
        width: double.infinity,
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            if (!fromNav)
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: buildIconButton(
                      icon: Icons.arrow_back_ios,
                      color: Colors.black,
                      onPressed: action),
                ),
              ),
            buildBorder(buildListTile(
                context: context,
                title: _strController.userPanel,
                hasLeading: true,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPanel(),
                      ),
                    ),
                iconL: Icons.account_circle,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                title: _strController.myAccount,
                hasLeading: true,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    ),
                iconL: Icons.account_circle,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAdsScreen(isPrivate:true,isFilter: false,isFav: false,fromHome: false,
                          actionTitle: '',
                        ),
                      ),
                    ),
                title: _strController.myAds,
                hasLeading: true,
                iconL: Icons.addchart_sharp,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.addchart_sharp,
                title: _strController.myPostsAds,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAdsScreen(isPrivate:true,isFilter: false,isFav: false,fromHome: false,
                          actionTitle: 'approved',
                        ),
                      ),
                    ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.post_add_sharp,
                title: _strController.myWaitingAds,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAdsScreen(isPrivate:true,isFav: false,isFilter: false,fromHome: false,
                          actionTitle: 'new',
                        ),
                      ),
                    ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.close,
                title: _strController.myRejectedAds,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAdsScreen(isPrivate:true,isFilter: false,isFav: false,fromHome: false,
                          actionTitle: 'rejected',
                        ),
                      ),
                    ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.close,
                title: _strController.expiredAds,
                tapHandler: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAdsScreen(isPrivate:true,isFav: false,isFilter: false,fromHome: false,
                          actionTitle: 'expired',
                        ),
                      ),
                    ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.favorite,
                title: _strController.myFavAds,
                tapHandler: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublicAdsScreen(isPrivate: false,isFav: true,isFilter: false,fromHome: false,)
                  ),
                ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.filter_list,
                title: _strController.filter,
                tapHandler: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAdSectionsScreen(comeFrom: 'filter',)
                  ),
                ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasLeading: true,
                iconL: Icons.add_circle,
                title: _strController.newAd,
                tapHandler: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAdSectionsScreen(comeFrom: 'addAd',)
                  ),
                ),
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                title: _strController.contactWithUs,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
              tapHandler: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(comeFrom: 'howWeAre',),)),
                context: context,
                title: _strController.whoAreWe,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                tapHandler: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(comeFrom: 't&c',),)),
                context: context,
                title: _strController.termsAndCon,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                tapHandler: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(comeFrom: 'privacy',),)),
                context: context,
                title: _strController.privacyPolicy,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                title: _strController.followUs,
                icon: Icons.arrow_forward_ios)),
            buildBorder(buildListTile(
                context: context,
                hasColor: true,
                tapHandler: () {
                  showLoadingHud(context: ctx,hudKey: _hudKey);
                  return logoutFunction(context: context);
                },
                title: _strController.logout,
                icon: Icons.logout)),
          ]).toList(),
        ),
      ),
    ),
  );
}

buildIconButton({IconData icon, Function onPressed, Color color, double size}) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      icon,
      color: color,
      size: size != null ? size : null,
    ),
  );
}

Widget buildBorder(Widget child) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          blurRadius: 1.0,
          color: Colors.grey[300],
          spreadRadius: 2.0,
        ),
      ],
      borderRadius: BorderRadius.circular(4),
      color: Colors.white,
    ),
    child: child,
  );
}

Widget buildListTile(
    {@required String title,
    IconData icon,
    IconData iconL,
    bool hasLeading = false,
    bool hasColor = false,
    Function tapHandler,
    @required BuildContext context}) {
  return ListTile(
    leading: hasLeading
        ? Icon(
            iconL,
            color: AppColors.blackColor,
            size: 24,
          )
        : null,
    trailing: Icon(
      icon,
      color: hasColor ? Colors.redAccent : AppColors.blackColor,
      size: 20,
    ),
    title: Text(
      title,
      style: appStyle(
        color: Theme.of(context).textTheme.button.color,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
    onTap: tapHandler,
  );
}

Widget buildLoading({@required Color color}) {
  return SpinKitCircle(
    color: color,
    // duration: Duration(seconds: 2),
    size: 70,
    // shape: BoxShape.rectangle,
    // type: SpinKitWaveType.center,
  );
}

myButton(
    {BuildContext context,
    Function onPressed,
    double radius,
    String shadowColor,
    Color txtColor,
    double fontSize,
    Color btnColor,
    String btnTxt,
    double height,
    double width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: AppColors.grey, offset: Offset(0, 1), blurRadius: 1)
        ]),
    child: FlatButton(
      onPressed: onPressed,
      child: Text(
        btnTxt,
        style: appStyle(color: txtColor, fontSize: fontSize,fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget buildBg() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
            image: AssetImage("assets/images/main_bg.png"), fit: BoxFit.cover)),
  );
}

buildLogo({@required double height}) {
  return new SizedBox(
    height: height,
    child: Image.asset(
      "assets/images/logo_icon.png",
      fit: BoxFit.contain,
    ),
  );
}

buildTxt(
    {@required txt,
    TextDecoration decoration,
    int maxLine,
    TextAlign textAlign,
    TextOverflow overflow,
    Color txtColor,
    double fontSize,
    FontWeight fontWeight,
    Function action}) {
  return GestureDetector(
    onTap: action,
    child: Text(
      txt,
      style: appStyle(
          color: txtColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: decoration != null ? decoration : null),
      maxLines: maxLine != null ? maxLine : null,
      textAlign: textAlign != null ? textAlign : null,
      overflow: overflow != null ? overflow : null,
    ),
  );
}

buildTextField({
  String hintTxt,
  String initialValue,
  bool fromAttributes=false,
  bool fromDialog = false,
  @required String label,
  TextInputType textInputType,
  bool fromPhone = false,
  TextEditingController controller,
  Function validator,
  Function onChanged,
  Function onSubmit,
  Widget suffixIcon,
  int minLines,
  int maxLines,
  int maxLength,
  bool isPassword = false,
}) {
  return Padding(
    padding: fromDialog?EdgeInsets.symmetric(vertical: 8):fromAttributes?EdgeInsets.only(bottom: 10,):const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.1),
      ),
      child: TextFormField(
        showCursor: true,
        initialValue: initialValue,
        maxLines: isPassword?1:maxLines,
        minLines: isPassword?1:minLines,
        onFieldSubmitted: onSubmit,
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        onChanged: onChanged,
        keyboardType: textInputType,
        obscureText: isPassword ,
        decoration: InputDecoration(
          errorStyle: appStyle(fontSize: 15,color: AppColors.redColor,fontWeight: FontWeight.w400),
          contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          suffixIcon:  suffixIcon ,
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          border: OutlineInputBorder(
            gapPadding: 3,
            borderSide: BorderSide(
              color: Colors.grey, //this has no effect
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelText: label,
          labelStyle: appStyle(fontSize: 18,color: AppColors.blackColor2),
          hintText: hintTxt,
        ),
        // ),
        // ],
      ),
    ),
  );
}

Container buildOr(double height) {
  return Container(
    height: height,
    child: Row(children: <Widget>[
      Expanded(
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(
            color: Colors.black26,
            height: 1,
          ),
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          AppController.strings.or,
          style: appStyle(color: Colors.white,fontWeight: FontWeight.w700),
        ),
      ),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(
              color: Colors.black26,
              height: 1,
            )),
      ),
    ]),
  );
}

Widget buildSocialIcons(
    {String url,
    EdgeInsetsGeometry margin,
    double width,
    double height,
    double borderRadius,
    BoxFit boxFit,
    Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(image: AssetImage(url), fit: boxFit),
      ),
    ),
  );
}

void viewToast(BuildContext context, String alert, Color color, int gravity) {
  return Toast.show(
    alert,
    context,
    duration: Toast.LENGTH_LONG,
    gravity: gravity,
    backgroundColor: color,
    textColor: Colors.white,
    backgroundRadius: 4,
  );
}

Widget buildIconWithTxt(
    {Function action,
    IconData iconData,
    double size,
    Color iconColor,
    Text label}) {
  return FlatButton.icon(
    onPressed: action,
    icon: Icon(
      iconData,
      color: iconColor,
      size: size,
    ),
    label: label,
  );
}

buildIcons(
    {IconData iconData,
    Color color,
    double size = 20,
    Function action,
      double width,
      double height,
    Color bgColor = Colors.white,
    bool hasShadow = false}) {
  return Container(
    width: width,
    height: height,
    margin: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: bgColor == Colors.white? Colors.white:bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                    offset: Offset(1, 1),
                    spreadRadius: 0.01,
                    blurRadius: 1)
              ]
            : []),
    child: IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: FaIcon(
        iconData,
        color: color,
        size: size,
      ),
      onPressed: action,
    ),
  );
}

showLoadingHud({BuildContext context,GlobalKey<ProgressHudState> hudKey,int time}) async {
  ProgressHud.of(context).show(ProgressHudType.loading, "loading...");
  await Future.delayed(Duration(milliseconds: time!=null?time:1600));
  hudKey.currentState?.dismiss();
}

buildDialog(
    {BuildContext context,
    //AlertType alertType,
    String title,
    String desc,
    String yes,
    String no,
      Widget content,
    Function action}) {
  return Alert(
    context: context,
    content: content,
    // type: AlertType.error,
    // style: AlertStyle(
    //   buttonAreaPadding: EdgeInsets.all(12)
    // ),
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        child: Text(
          no,
          style: appStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        // color: AppColors.whiteColor.withOpacity(0.1),
        gradient: LinearGradient(colors: [Colors.redAccent, Colors.red]),
      ),
      DialogButton(width: MediaQuery.of(context).size.width*1,
        child: Text(
          yes,
          style: appStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: action,
        // color: AppColors.whiteColor.withOpacity(0.1),
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    ],
  ).show();
}

//ListItem
Widget listItem(BuildContext context, LinearGradient gradient,Color color, String title,
    var count, double width, double height,
    {String actionTitle, bool hasList}) {
  return GestureDetector(
    onTap: () {
      if (hasList != false)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => actionTitle == 'fav'?PublicAdsScreen(isPrivate: false,isFav: true,isFilter: false,fromHome: false,):PublicAdsScreen(isPrivate:true,fromHome: false,isFav: false,isFilter: false,
              actionTitle: actionTitle,
            ),
          ),
        );
    },
    child: Card(
      elevation: 1,
      child: Container(
        width: width != null ? width : MediaQuery.of(context).size.width * 0.4,
        height:
            height != null ? height : MediaQuery.of(context).size.height * 0.2,
         
        decoration: BoxDecoration(
            // gradient: gradient,
          boxShadow: [
            BoxShadow(color: AppColors.grey.withOpacity(0.4),offset: Offset(1,2))
          ],
          color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: appStyle(
                    color: AppColors.blackColor2.withOpacity(0.8),
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              if (count != "empty")
                Text(
                  "$count",
                  style: TextStyle(
                      color: AppColors.blackColor2.withOpacity(0.6),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
             ],
          ),
        ),
      ),
    ),
  );
}

Widget myIcon(
  BuildContext context,
  IconData icon, {
  Color color = Colors.grey,
  double size = 30,
  double width = 30,
  double height = 30,
  bool hasDecoration = true,
  Function onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
        decoration: hasDecoration
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1), color: Colors.grey, blurRadius: 4)
                  ])
            : null,
        height: height,
        width: width,
        child: Icon(
          icon,
          size: size,
          color: color,
        )),
    //Icon(icon, color: color, size: size)),
  );
}

Future<void> showInformationDialog({
  BuildContext context,
  TextEditingController emailController,
  TextEditingController phoneController,
  TextEditingController nickNameController,
  int countryIsoCode,
  String countryCode,
  bool hasEmail,
  String social,
  Function onPressed,
  var cancel,
  GlobalKey<FormState> formKey,
}) async {
  SharedPreferences _gp = await SharedPreferences.getInstance();
  final List countries = jsonDecode(_gp.getString("allCountriesData"));
  List _countryData = countries[0]['responseData'];

  String _chosenValue;
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Form(
              key: formKey,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _chosenValue,
                            hint: Text(
                              AppController.strings.errorCountry,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (listSub) {
                              setState(() {
                                _chosenValue = listSub;
                              });
                            },
                            items: _countryData
                                    .where((element) =>
                                        element['classified'] == true)
                                    .map((listSub) {
                                  return new DropdownMenuItem(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(listSub['name']),
                                        CircleAvatar(
                                          radius: 20.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${listSub['flag']}"),
                                                    fit: BoxFit.cover)),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        )
                                      ],
                                    ),
                                    value: listSub['id'].toString(),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: nickNameController,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Enter any text";
                      },
                      decoration:
                          InputDecoration(hintText: _strController.nickName),
                    ),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Enter any text";
                      },
                      decoration:
                          InputDecoration(hintText: _strController.mobile),
                    ),
                    if (hasEmail == false)
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter any text";
                        },
                        decoration:
                            InputDecoration(hintText: _strController.email),
                      ),
                  ],
                ),
              )),
          title: Text('Required Data'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  child: Text(_strController.done),
                  onTap: onPressed,
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Text(_strController.cancel),
                  onTap: () {
                    cancel;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      });
    },
  );
}


String validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return AppController.strings.emptyNickName;
  }else if(value.length < 3){
    return AppController.strings.errorOneNickName;
  }else if(value.length > 20){
    return AppController.strings.errorTwoNickName;
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}

String validatePassword(String value) {
  if (value.length == 0) {
    return AppController.strings.emptyPassword;
  }else if(value.length < 8){
    return AppController.strings.errorPassword;
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}

String validateMobile(String value) {
  // String patttern = r'(^[0-9]*$)';
  // RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return AppController.strings.emptyMobile;
  } else if(value.length < 7){
    return AppController.strings.errorMobile;
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Mobile Number must be digits";
  // }
  return null;
}

String validateEmail(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return AppController.strings.emptyEmail;
  } else if(!regExp.hasMatch(value)){
    return AppController.strings.errorEmail;
  }else {
    return null;
  }
}

String validateTitle(String value) {
  String pattern = r'^[a-zA-Z0-9\u0621-\u064A\u0660-\u0669.\-() ]+$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return AppController.strings.emptyTitle;
  }else if(value.length < 15) {
    return AppController.strings.errorTitle;
  } else if(!regExp.hasMatch(value)){
    return AppController.strings.errorTitleTwo;
  }else {
    return null;
  }
}
String validateBody(String value) {
  if (value.length == 0) {
    return AppController.strings.emptyBody;
  } else if(value.length < 30){
    return AppController.strings.errorBody;
  }else {
    return null;
  }
}
String validateCity(String value) {
  if (value == null) {
    return AppController.strings.errorCity;
  }else{
    return null;
  }
}
String validateCurrency(String value) {
  if (value == null) {
    return AppController.strings.errorCurrency;
  }else{
    return null;
  }
}
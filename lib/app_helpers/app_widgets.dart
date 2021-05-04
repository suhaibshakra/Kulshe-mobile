import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/ui/ads_package/public_ads_list_screen.dart';
import 'package:kulshe/ui/ads_package/user_panel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_helpers/app_controller.dart';
import '../services_api/api.dart';
import '../ui/ads_package/private_ads_list_screen.dart';
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
      child: CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage('assets/images/logo_icon.png'),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}

buildDrawer(BuildContext context, Function action, {fromNav = false}) {
  return Container(
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
                    builder: (context) => PrivateAdsListScreen(
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
                    builder: (context) => PrivateAdsListScreen(
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
                    builder: (context) => PrivateAdsListScreen(
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
                    builder: (context) => PrivateAdsListScreen(
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
                    builder: (context) => PrivateAdsListScreen(
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
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            hasLeading: true,
            iconL: Icons.widgets_outlined,
            title: _strController.categories,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            hasLeading: true,
            iconL: Icons.filter_list,
            title: _strController.filter,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            hasLeading: true,
            iconL: Icons.add_circle,
            title: _strController.newAd,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            title: _strController.contactWithUs,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            title: _strController.whoAreWe,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            title: _strController.termsAndCon,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            title: _strController.followUs,
            icon: Icons.arrow_forward_ios)),
        buildBorder(buildListTile(
            context: context,
            hasColor: true,
            tapHandler: () => logoutFunction(context: context),
            title: _strController.logout,
            icon: Icons.logout)),
      ]).toList(),
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
      style: TextStyle(
        color: Theme.of(context).textTheme.button.color,
        fontFamily: 'RobotoCondensed',
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
  bool fromDialog = false,
  @required String label,
  TextInputType textInputType,
  bool fromPhone = false,
  TextEditingController controller,
  Function validator,
  Function onChanged,
  Function onSubmit,
  Widget suffix,
  int minLines,
  int maxLines,
  bool isPassword = false,
}) {
  return Padding(
    padding: fromDialog?EdgeInsets.symmetric(vertical: 8):const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
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
        onChanged: onChanged,
        keyboardType: textInputType,
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          suffix: fromPhone ? suffix : null,
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
    Color bgColor = Colors.white,
    bool hasShadow = true}) {
  return Container(
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: bgColor == Colors.white? Colors.white.withOpacity(0.4):bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: hasShadow
            ? [
                // BoxShadow(
                //     offset: Offset(0, 0),
                //     spreadRadius: 0.01,
                //     blurRadius: 1)
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
Widget listItem(BuildContext context, LinearGradient gradient, String title,
    var count, double width, double height,
    {String actionTitle, bool hasList}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: GestureDetector(
      onTap: () {
        if (hasList != false)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => actionTitle == 'fav'?PublicAdsListScreen(isFav: true,isFilter: false,isMain: false,):PrivateAdsListScreen(
                actionTitle: actionTitle,
              ),
            ),
          );
      },
      child: Container(
        width: width != null ? width : MediaQuery.of(context).size.width * 0.4,
        height:
            height != null ? height : MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(),
            Text(
              title,
              style: appStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            if (count != "empty")
              Text(
                "$count",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
            Center(),
          ],
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

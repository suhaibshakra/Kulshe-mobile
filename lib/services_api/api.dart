import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/app_helpers/shared_preferences.dart';
import 'package:kulshe/ui/auth/login.dart';
import 'package:kulshe/ui/auth/social_media/google_login.dart';
import 'package:kulshe/ui/main_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

const String baseURL = 'https://api.kulshe.nurdevops.com/api/v1/';

const String sections = 'sections';
var headers = {'lang': 'ar', 'Accept': 'application/json'};
var headersUpdate = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

// Future getTokens() async {
//   try {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     return _preferences.getString('token');
//   } catch (e) {
//     print(e);
//   }
// }

Future getSectionsSP(List list, {Function action}) async {
  SharedPreferences _gp = await SharedPreferences.getInstance();
  final List sections = jsonDecode(_gp.getString("allSectionsData"));
  list = sections[0].responseData;
  if (action != null) action();
}

// var mainHeaders = {'lang': 'ar', 'Accept': 'application/json'};
// login method...
Future loginFunction(
    {String email, String password, BuildContext context}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  map['email'] = email.trim();
  map['password'] = password;

  http.Response response = await http.post('${baseURL}login',
      body: map,
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json'
      });
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200 && decodedData['custom_code'] != 2166) {
    viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  } else if (decodedData['custom_code'] == 2166) {
    return decodedData;
  } else {
    var mainToken = decodedData['token_data']['token'];
    var refreshToken = decodedData['token_data']['token'];
    var id = decodedData['token_data']['user_id'];
    bool isEmailVerified = decodedData['token_data']['is_email_verified'];

    print('TOKEN: \n \n$mainToken \n \n');
    print('REFRESH TOKEN: \n \n$refreshToken \n \n');
    print('Is Email Verified:  $isEmailVerified \n \n');
    print('Is ID:  $id \n \n');

    AppSharedPreferences.saveTokenSP(mainToken.toString());
    AppSharedPreferences.saveUserId(id.toString());
    AppSharedPreferences.saveRefreshTokenSP(
        'bearer ${refreshToken.toString()}');
    AppSharedPreferences.saveIsEmailVerified(isEmailVerified);
    AppSharedPreferences.saveCountryId(
        decodedData['token_data']['country_id'].toString());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainBottomNavigation(),
      ),
    );
    // print(response.body);
    // print(decodedData);
  }
  // return decodedData;
}

Future verifyEmail({@required BuildContext context}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  map['token'] = '${_pref.getString('token')}';
  map['id'] = '${_pref.getString('uID')}';

  http.Response response =
      await http.post('${baseURL}send-verify-email', body: map, headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'token': '${_pref.getString('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
  });
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200 && decodedData['custom_code'] != 2166) {
    viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  } else {
    viewToast(context, '${decodedData['custom_message']}', AppColors.green,
        Toast.BOTTOM);
  }
  // return decodedData;
}

Future changePasswordSocial(BuildContext context, String password,
    String confirmPassword, String newToken) async {
  print('$newToken');
  SharedPreferences _pref = await SharedPreferences.getInstance();

  var map = Map<String, dynamic>();
  map['password'] = password;
  map['confirmPassword'] = confirmPassword;
  map['token'] = newToken;

  http.Response response = await http.post('${baseURL}change-password-social',
      body: map,
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json'
      });
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200) {
    viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  } else {
    viewToast(context, '${decodedData['custom_message']}', AppColors.green,
        Toast.BOTTOM);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}

//forget password
Future forgetPasswordEmail(BuildContext context, String bodyData) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  map['email'] = bodyData;

  http.Response response = await http.post('${baseURL}reset-password',
      body: map,
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json'
      });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

//add image
Future uploadImage(BuildContext context, String bodyData) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  map['image'] = bodyData;

  http.Response response =
      await http.post('${baseURL}classified/upload-image', body: map, headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'token': _pref.getString('token'),
    'Authorization': 'bearer ${_pref.getString('token')}'
  });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    // viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
    //     Toast.BOTTOM);
    return jsonDecode('[${response.body}]');
  } else {
    print(decodeData['custom_message']);
    print('********************************Wrong');
    // viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
    //     Toast.BOTTOM);
  }
}

//Delete ad
Future deleteAd({BuildContext context, @required int adId}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var map = Map<String, dynamic>();
  http.Response response = await http
      .post('${baseURL}user/classifieds/$adId/delete', body: map, headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'token': '${_pref.getString('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
  });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.CENTER);
  } else {
    print(decodeData['custom_message']);
    // viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
    //     Toast.CENTER);
  }
}

//Pause ad
Future pauseAd({
  @required BuildContext context,
  @required int adId,
  @required int pausedStatus,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  http.Response response = await http.get(
      '${baseURL}user/classifieds/$adId/paused?paused=$pausedStatus',
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json',
        'token': '${_pref.getString('token')}',
        'Authorization': 'bearer ${_pref.getString('token')}',
      });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

//renew ad
Future reNewAd({
  @required BuildContext context,
  @required int adId,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  http.Response response =
      await http.get('${baseURL}user/classifieds/$adId/renew', headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'token': '${_pref.getString('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
  });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

//abuse ad
Future abuseAd({
  @required BuildContext context,
  @required int adId,
  @required int abuseId,
  String abuseDescription,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  var body =
      json.encode({'abuseId': abuseId, 'abuseDescription': abuseDescription});
  http.Response response =
      await http.post('${baseURL}user/classifieds/$adId/abuse',
          headers: {
            'lang': _pref.getString('lang') ?? 'ar',
            'Content-Type': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}',
          },
          body: body);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');

    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
    return "done";
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
    return "wrong";
  }
}

// void showInSnackBar(String value,GlobalKey<ScaffoldState> _scaffoldKey) {
//   _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
// }

//abuse ad
Future sendMessage({
  @required BuildContext context,
  @required int adId,
  @required String txtBody,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  var body = json.encode({'body': txtBody});
  http.Response response = await http.post('${baseURL}email-messages/$adId',
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Content-Type': 'application/json',
        'token': '${_pref.getString('token')}',
        'Authorization': 'bearer ${_pref.getString('token')}',
      },
      body: body);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

// void showInSnackBar(String value,GlobalKey<ScaffoldState> _scaffoldKey) {
//   _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
// }
//favorite
Future favoriteAd(
    {@required BuildContext context,
    @required int adId,
    @required String state,
    GlobalKey<ScaffoldState> scaffoldKey}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  http.Response response = await http
      .get('${baseURL}user/classifieds/$adId/favorite/$state', headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'token': '${_pref.getString('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
  });
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    print('${decodeData['custom_code']}');
    print('${decodeData['custom_message']}');
    print('********************************Done');
    // scaffoldKey.currentState.showSnackBar(new SnackBar(action: SnackBarAction(
    //   label: 'حسنا',
    //   textColor: AppColors.whiteColor,
    //   onPressed: () {
    //     // Some code to undo the change.
    //   },
    // ),duration: Duration(milliseconds: 3000),backgroundColor: Colors.green.shade300,content: new Text('${decodeData['custom_message']}',style: appStyle(fontWeight: FontWeight.bold,fontSize: 15,color: AppColors.whiteColor),)));
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
    return decodeData['custom_code'];
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

Future createAccountFunction({
  BuildContext context,
  String nickName,
  String mobileNumber,
  String email,
  String password,
  String confirmPassword,
  String countryId,
  String mobileCountryPhoneCode,
  String mobileCountryIsoCode,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  print('nickName : $nickName');
  print('mobileNumber : $mobileNumber');
  print('email : $email');
  print('password : $password');
  print('confirmPassword : $confirmPassword');
  print('countryId : $countryId');
  print('mobileCountryPhoneCode : $mobileCountryPhoneCode');
  print('mobileCountryIsoCode : $mobileCountryIsoCode');

  var map = Map<String, dynamic>();
  map['email'] = email;
  map['password'] = password;
  map['confirmPassword'] = confirmPassword;
  map['countryId'] = countryId;
  map['nickName'] = nickName;
  map['mobileNumber'] = mobileNumber;
  map['mobileCountryPhoneCode'] = mobileCountryPhoneCode;
  map['mobileCountryIsoCode'] = mobileCountryIsoCode;
  map['comeFrom'] = "m";
  var response = await http.post('${baseURL}register',
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json'
      },
      body: map);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);

    loginFunction(email: email,password: password,context: context);
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

Future updateProfile({
  String nickName,
  String fullName,
  String email,
  String newPassword,
  String oldPassword,
  String confirmPassword,
  String mobileNumber,
  String mobileCountryIsoCode,
  String mobileCountryCode,
  String additionalPhoneNumber,
  String additionalPhoneCountryIsoCode,
  String additionalPhoneCountryCode,
  String countryId,
  bool newsLetter,
  bool promotions,
  bool showContactInfo,
  String profileImage,
  String currentLang,
  BuildContext context,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  // var map = Map<String, dynamic>();
  // map['email'] = email;
  // map['old_password'] = oldPassword;
  // map['password'] = newPassword;
  // map['confirm_password'] = confirmPassword;
  // map['nick_name'] = nickName;
  // map['full_name'] = fullName;
  // map['mobile_number'] = mobileNumber;
  // map['mobile_country_iso_code'] = mobileCountryIsoCode;
  // map['mobile_country_code'] = mobileCountryCode;
  // map['additional_phone_number'] = additionalPhoneNumber;
  // map['additional_phone_country_iso_code'] = additionalPhoneCountryIsoCode;
  // map['additional_phone_country_code'] = additionalPhoneCountryCode;
  // map['country_id'] = countryId;
  // map['newsletter'] = 0 ;
  // map['promotions'] = 1 ;
  // map['show_contact_info'] = 1 ;
  // map['profile_image'] = profileImage;
  // map['current_lang'] = currentLang;

  // print('DATa DECODED : ${jsonEncode(map)}');
  var body = json.encode({
    'email': email,
    'old_password': oldPassword,
    'password': newPassword,
    'confirm_password': confirmPassword,
    'nick_name': nickName,
    'full_name': fullName,
    'mobile_number': mobileNumber,
    'mobile_country_iso_code': mobileCountryIsoCode,
    'mobile_country_code': mobileCountryCode,
    'additional_phone_number': additionalPhoneNumber,
    'additional_phone_country_iso_code': additionalPhoneCountryIsoCode,
    'additional_phone_country_code': additionalPhoneCountryCode,
    'country_id': countryId,
    'newsletter': newsLetter,
    'promotions': promotions,
    'show_contact_info': showContactInfo,
    'profile_image': profileImage,
    'current_lang': currentLang,
  });
  var response = await http.post('${baseURL}profile',
      headers: {
        'token': _pref.getString('token'),
        'Authorization': "bearer ${_pref.getString('token')}",
        'lang': _pref.getString('lang') ?? 'ar',
        'Content-Type': 'application/json'
      },
      body: body);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    AppSharedPreferences.saveCountryId(countryId);
    if ((oldPassword != null && oldPassword.isNotEmpty && oldPassword != "") &&
        (newPassword != null && newPassword.isNotEmpty && newPassword != "") &&
        (confirmPassword != null &&
            confirmPassword.isNotEmpty &&
            confirmPassword != "")) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
  } else {
    print(decodeData['custom_message']);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  }
}

Future addAdFunction({
  @required BuildContext context,
  String sectionId,
  String subSectionId,
  String cityId,
  String localityId,
  String brandId,
  String subBrandId,
  String title,
  String bodyAd,
  String currencyId,
  String lat,
  String lag,
  double price,
  int zoom,
  bool negotiable,
  bool isFree,
  bool isDelivery,
  bool showContact,
  String video,
  List adAttributes,
  List images,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var headers = {
    'token': '${_pref.get('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
    'lang': '${_pref.getString('lang') ?? 'ar'}',
    'Content-Type': 'application/json'
  };

  var body = json.encode({
    "section_id": sectionId,
    "sub_section_id": subSectionId,
    "country_id": _pref.getString('countryId'),
    "city_id": cityId,
    "locality_id": localityId,
    "brand_id": brandId,
    "sub_brand_id": subBrandId,
    "title": title,
    "body": bodyAd,
    "currency_id": currencyId,
    "lat": lat,
    "lag": lag,
    "price": price,
    "zoom": zoom,
    "negotiable": negotiable,
    "is_free": isFree,
    "is_delivery": isDelivery,
    "show_contact": showContact,
    "video": video,
    //https://www.youtube.com/watch?v=kSDJZTzCl8k
    "ad_attributes": adAttributes,
    "images": images
  });
  var response = await http.post(
      'https://api.kulshe.nurdevops.com/api/v1/classified',
      headers: headers,
      body: body);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print('body');
    print(body);
    print('body');
    print('********************************${decodeData['custom_message']}');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
    return response.statusCode;
  } else {
    print(decodeData['custom_message']);
    print(body);
    print(decodeData);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
    return response.statusCode;
  }
}

Future updateAdFunction({
  @required BuildContext context,
  String adID,
  String cityId,
  String localityId,
  String brandId,
  String subBrandId,
  String title,
  String bodyAd,
  String currencyId,
  String lat,
  String lag,
  double price,
  int zoom,
  bool negotiable,
  bool isFree,
  bool isDelivery,
  bool showContact,
  String video,
  List adAttributes,
  List images,
}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var headers = {
    'token': '${_pref.get('token')}',
    'Authorization': 'bearer ${_pref.getString('token')}',
    'lang': '${_pref.getString('lang') ?? 'ar'}',
    'Content-Type': 'application/json'
  };

  var body = json.encode({
    "ad_id": adID,
    "country_id": _pref.getString('countryId'),
    "city_id": cityId,
    "locality_id": localityId,
    "brand_id": brandId,
    "sub_brand_id": subBrandId,
    "title": title,
    "body": bodyAd,
    "currency_id": currencyId,
    "lat": lat,
    "lag": lag,
    "price": price,
    "zoom": zoom,
    "negotiable": negotiable,
    "is_free": isFree,
    "is_delivery": isDelivery,
    "show_contact": showContact,
    "video": video,
    //https://www.youtube.com/watch?v=kSDJZTzCl8k
    "ad_attributes": adAttributes,
    "images": images

  });
  var response = await http.post(
      'https://api.kulshe.nurdevops.com/api/v1/classified/update',
      headers: headers,
      body: body);
  log(body);

  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {

    print('********************************${decodeData['custom_message']}');
    viewToast(context, '${decodeData['custom_message']}', AppColors.greenColor,
        Toast.BOTTOM);
    return response.statusCode;
  } else {
    print(decodeData['custom_message']);
    print(body);
    print(decodeData);
    viewToast(context, '${decodeData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
    return response.statusCode;
  }
}

Future logoutFunction({BuildContext context}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String token = _pref.getString("token");
  var map = Map<String, dynamic>();
  map['token'] = token;
  map['refresh_token'] = "bearer $token";

  http.Response response = await http.post('${baseURL}logout',
      body: map,
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Accept': 'application/json'
      });
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200) {
    print(response.statusCode);
    viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
  } else {
    viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
        Toast.BOTTOM);
    // signOutGoogle();
    // _logoutFacebook();
    AppSharedPreferences.saveTokenSP(null);
    AppSharedPreferences.saveRefreshTokenSP(null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}

var _facebookLogin = FacebookLogin();

_logoutFacebook() async {
  await _facebookLogin.logOut();
  print("Logged out");
}

Future maxPrice({BuildContext context, @required int subSectionId}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  http.Response response =
      await http.get('${baseURL}classified/$subSectionId/max-price', headers: {
    'lang': _pref.getString('lang') ?? 'ar',
    'Accept': 'application/json',
    'Country-id': _pref.getString('countryId')
  });
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200) {
    print(response.statusCode);
    // viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,
    //     Toast.BOTTOM);
  } else {
    // viewToast(context, '${decodedData['custom_message']}', AppColors.greenColor,
    //     Toast.BOTTOM);
    return decodedData;
  }
}

Future<bool> emailStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("isEmailVerified");
}

//social

Future createAccountFunctionGoogle(
    {BuildContext context,
    String gId,
    String gToken,
    String email,
    String nickName,
    String userImage,
    String mobileNumber,
    String mobileCountryPhoneCode,
    String mobileCountryIsoCode,
    String countryId}) async {
  print('gId $gId');
  print('gToken $gToken');
  print('email $email');
  print('nickName $nickName');
  print('userImage $userImage');
  print('mobileNumber $mobileNumber');
  print('mobileCountryPhoneCode $mobileCountryPhoneCode');
  print('mobileCountryIsoCode $mobileCountryIsoCode');
  print('countryId $countryId');
  SharedPreferences _pref = await SharedPreferences.getInstance();

  var body = jsonEncode({
    'email': email,
    'googleId': gId,
    'googleToken': gToken,
    'nickName': nickName,
    'comeFrom': 'm',
    'userImage': userImage,
    'mobileNumber': mobileNumber,
    'mobileCountryPhoneCode': mobileCountryPhoneCode,
    'mobileCountryIsoCode': mobileCountryIsoCode,
    'countryId': countryId
  });
  var response = await http.post('${baseURL}login/google',
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Content-Type': 'application/json'
      },
      body: body);
  var decodedData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    var mainToken = decodedData['token_data']['token'];
    var refreshToken = decodedData['token_data']['token'];
    bool isEmailVerified = decodedData['token_data']['is_email_verified'];

    print('TOKEN: \n \n$mainToken \n \n');
    print('REFRESH TOKEN: \n \n$refreshToken \n \n');
    print('Is Email Verified:  $isEmailVerified \n \n');

    AppSharedPreferences.saveTokenSP(mainToken.toString());
    AppSharedPreferences.saveRefreshTokenSP(
        'bearer ${refreshToken.toString()}');
    AppSharedPreferences.saveIsEmailVerified(isEmailVerified);
    AppSharedPreferences.saveCountryId(
        decodedData['token_data']['country_id'].toString());

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavigation(),
        ));
    print('********************************Done');
    print(decodedData);
    // viewToast(context, '${decodedData['custom_message']}', AppColors.redColor,        Toast.BOTTOM);

  } else {
    print(decodedData);
    print(decodedData['custom_code']);
    print('********************************Wrong');
    return decodedData['custom_code'];

    // viewToast(context, '${decodedData['custom_message']}', AppColors.greenColor,
    //     Toast.BOTTOM);  }
  }
}

Future createAccountFunctionFacebook(
    {BuildContext context,
    String email,
    String fbId,
    String fbToken,
    String nickName,
    String userImage,
    String mobileNumber,
    String mobileCountryPhoneCode,
    String mobileCountryIsoCode,
    String countryId}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var body = jsonEncode({
    'email': email,
    'fbId': fbId,
    'fbToken': fbToken,
    'nickName': nickName,
    'comeFrom': 'm',
    'userImage': userImage,
    'mobileNumber': mobileNumber,
    'mobileCountryPhoneCode': mobileCountryPhoneCode,
    'mobileCountryIsoCode': mobileCountryIsoCode,
    'countryId': countryId
  });
  var response = await http.post(
      'https://api.kulshe.nurdevops.com/api/v1/login/facebook',
      headers: {
        'lang': _pref.getString('lang') ?? 'ar',
        'Content-Type': 'application/json'
      },
      body: body);
  //
  print('email : $email');
  print('fbId : $fbId');
  print('fbToken : $fbToken');
  print('nickName : $nickName');
  print('userImage : $userImage');
  print('mobileNumber : $mobileNumber');
  print('mobileCountryPhoneCode : $mobileCountryPhoneCode');
  print('mobileCountryIsoCode : $mobileCountryIsoCode');
  print('countryId : $countryId');

  var decodedData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    var mainToken = decodedData['token_data']['token'];
    var refreshToken = decodedData['token_data']['token'];
    bool isEmailVerified = decodedData['token_data']['is_email_verified'];

    print('TOKEN: \n \n$mainToken \n \n');
    print('REFRESH TOKEN: \n \n$refreshToken \n \n');
    print('Is Email Verified:  $isEmailVerified \n \n');

    AppSharedPreferences.saveTokenSP(mainToken.toString());
    AppSharedPreferences.saveRefreshTokenSP(
        'bearer ${refreshToken.toString()}');
    AppSharedPreferences.saveIsEmailVerified(isEmailVerified);
    AppSharedPreferences.saveCountryId(
        decodedData['token_data']['country_id'].toString());

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavigation(),
        ));
    print('********************************Done');
    // _widgets.viewToast('${decodeData['custom_message']}', AppColors.greenColor);
  } else {
    print(decodedData['custom_message']);
    print(decodedData['custom_code']);
    print('********************************Not Done');
    return decodedData['custom_code']; //2095
    // _widgets.viewToast('${decodeData['custom_message']}', AppColors.redColor);
  }
}

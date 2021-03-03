import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../nav_page.dart';
import '../utilities/app_helpers/app_colors.dart';
import 'package:toast/toast.dart';
import '../utilities/app_helpers/my_widgets.dart';
import '../shared.dart';
import 'api_url.dart';

var mainHeaders = {
  'lang': 'ar',
  'Accept': 'application/json'
};
// login method...
Future<List<Map<String, dynamic>>> loginFunction(
    {String email, String password, BuildContext context}) async {
  var map = Map<String, dynamic>();
  map['email'] = email;
  map['password'] = password;

  http.Response response =
  await http.post('${baseURL}login', body: map, headers: mainHeaders);
  var decodedData = jsonDecode(response.body);

  if (response.statusCode != 200) {
    viewToast(context,'${decodedData['custom_message']}', AppColors.redColor,Toast.BOTTOM);
  } else {
    var mainToken = decodedData['token_data']['token'];
    var refreshToken = decodedData['token_data']['token'];

    print('TOKEN: \n \n$mainToken \n \n');
    print('REFRESH TOKEN: \n \n$refreshToken \n \n');

    AppSharedPreferences.saveTokenSP(mainToken.toString());
    AppSharedPreferences.saveRefreshTokenSP(
        'bearer ${refreshToken.toString()}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavPage(),
      ),
    );
    // print(response.body);
    // print(decodedData);
  }
  // return decodedData;
}

//forget password
Future forgetPasswordEmail(BuildContext context,String bodyData) async {
  var map = Map<String, dynamic>();
  map['email'] = bodyData;

  http.Response response =
  await http.post('${baseURL}reset-password', body: map, headers: headers);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context,'${decodeData['custom_message']}', AppColors.greenColor,Toast.CENTER);
  } else {
    print(decodeData['custom_message']);
    viewToast(context,'${decodeData['custom_message']}', AppColors.redColor,Toast.CENTER);
  }
}

Future createAccountFunction(
    {BuildContext context,
      String nickName,
      String mobileNumber,
      String email,
      String password,
      String confirmPassword,
      String countryId,
      String mobileCountryPhoneCode,
      String mobileCountryIsoCode}) async {
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
  var response =
  await http.post('${baseURL}register', headers: headers, body: map);
  var decodeData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    print('********************************Done');
    viewToast(context,'${decodeData['custom_message']}', AppColors.greenColor,Toast.BOTTOM);
  } else {
    print(decodeData['custom_message']);
    viewToast(context,'${decodeData['custom_message']}', AppColors.redColor,Toast.BOTTOM);
  }
}
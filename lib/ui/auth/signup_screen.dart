import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'social_media/google_login.dart';
import 'social_media_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _phoneControllerS = TextEditingController()..text;
  TextEditingController _nickNameControllerS = TextEditingController()..text;

  TextEditingController _countryController = TextEditingController()..text;
  TextEditingController _nickNameController = TextEditingController()..text;
  TextEditingController _emailController = TextEditingController()..text;
  TextEditingController _phoneController = TextEditingController()..text;
  TextEditingController _passwordController = TextEditingController()..text;
  // TextEditingController mobileCountryPhoneCode = TextEditingController()..text;
  // TextEditingController mobileCountryIsoCode = TextEditingController()..text;
  TextEditingController _confirmPasswordController = TextEditingController()
    ..text;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var facebookLoginResult;
  String _selectedCountry = AppController.strings.selectCountry;
  bool isHiddenNew = true;
  bool isHiddenConfirm = true;
  String _myCountry;

  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  String mobileCountryPhoneCode = "962";
  String mobileCountryIsoCode = "JO";

  void _validateAndSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      createAccountFunction(
          context: context,
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString(),
          confirmPassword: _confirmPasswordController.text.toString(),
          countryId: _myCountry.trim(),
          mobileNumber: _phoneController.text[0].toString() == "0"
              ? _phoneController.text.replaceFirst('0', '').toString().trim()
              : _phoneController.text.toString().trim(),
          nickName: _nickNameController.text.toString().trim(),
          mobileCountryIsoCode: mobileCountryIsoCode,
          mobileCountryPhoneCode: mobileCountryPhoneCode);
    } else {
      print('Form is invalid');
    }
  }

  List _countryData;

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    _countryData = countries[0]['responseData'];
    setState(() {
      _countryData = _countryData
          .where((element) => element['classified'] == true)
          .toList();
    });

    print('_${_countryData.where((element) => element['classified'] == true)}');
  }

  @override
  void initState() {
    setState(() {
      _getCountries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Directionality(
        textDirection: _drController,
        child: Scaffold(
          // appBar: buildAppBar(
          //     centerTitle: true,
          //     bgColor: AppColors.whiteColor,
          //     themeColor: Colors.grey),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              buildBg(),
              SingleChildScrollView(
                child: Container(
                  padding: isLandscape
                      ? EdgeInsets.symmetric(vertical: 20, horizontal: 50)
                      : EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  height:
                      isLandscape ? mq.size.height * 1.5 : mq.size.height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: buildLogo(height: mq.size.height* 0.15),
                      ),
                      // Container(
                      //   margin: EdgeInsets.all(16),
                      //   child: buildTxt(
                      //       txt: _strController.createAccount,
                      //       fontSize: 25,
                      //       txtColor: AppColors.redColor),
                      // ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 8, left: 5, right: 5),
                                child: myButton(
                                    txtColor: AppColors.blackColor,
                                    fontSize: 18,
                                    context: context,
                                    btnColor: AppColors.whiteColor.withOpacity(0.9),
                                    radius: 4,
                                    btnTxt: _selectedCountry,
                                    width: double.infinity,
                                    onPressed: () =>
                                        _showCountriesDialog(mq: mq)),
                              ),
                              buildTextField(
                                label: _strController.nickName,
                                hintTxt: "إدخال اسم المستخدم",
                                controller: _nickNameController,
                                textInputType: TextInputType.name,
                                validator: (value) =>
                                    (value.length < 3 || value.isEmpty)
                                        ? "الحد الأدنى 3 احرف"
                                        : null,
                              ),
                              buildTextField(
                                label: _strController.email,
                                hintTxt: "البريد الإلكتروني",
                                textInputType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "يرجى إدخال بريد الكتروني صالح",
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 46,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.6),
                                                  border: Border.all(width: 1, color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: CountryListPick(
                                                appBar: AppBar(
                                                  backgroundColor: Colors.blue,
                                                  title: Text(
                                                    _strController.country,
                                                    style: appStyle(
                                                        fontSize: 18, fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                                theme: CountryTheme(
                                                    isShowFlag: true,
                                                    isShowTitle: false,
                                                    isShowCode: true,
                                                    isDownIcon: false,
                                                    showEnglishName: false,
                                                    initialSelection: '+962'),
                                                initialSelection: '+962',
                                                useSafeArea: true,
                                                onChanged: (CountryCode code) {

                                                  // print(code.name);
                                                  // print(code.code);
                                                  // print(code.dialCode);
                                                  // print(code.dialCode);
                                                  // print(code.dialCode);
                                                  // print(code.flagUri);
                                                  setState(() {
                                                    mobileCountryIsoCode = code.code.toString();
                                                    mobileCountryPhoneCode =
                                                        code.dialCode.replaceAll('+', '').toString();
                                                    print('code : ${code.code}');
                                                    print('code iso : ${mobileCountryIsoCode}');
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: buildTextField(
                                                fromPhone: true,
                                                validator: (value) =>
                                                    (value.length > 11 ||
                                                            value.length < 9 ||
                                                            value.isEmpty)
                                                        ? "أدخل رقم صحيح"
                                                        : null,
                                                controller: _phoneController,
                                                textInputType:
                                                    TextInputType.phone,
                                                label: _strController.mobile,
                                                hintTxt: "أدخل رقم الهاتف"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              buildTextField(
                                  validator: (value) =>
                                      (value.length < 8 || value.isEmpty)
                                          ? "يجب ان لا تقل عن 8 حروف":(value !=
                                          _confirmPasswordController.text
                                              .toString() ||
                                          value.isEmpty)
                                          ? "يجب تطابق كلمتي السر"
                                          : null,
                                  controller: _passwordController,
                                  textInputType: TextInputType.visiblePassword,
                                  label: _strController.password,
                                  isPassword: isHiddenNew,
                                suffixIcon: InkWell(
                                  onTap: (){setState(() {
                                    isHiddenNew = !isHiddenNew;
                                  });},
                                  child: Icon(isHiddenNew?Icons.visibility
                                      :Icons.visibility_off),
                                ),
                              ),
                              buildTextField(
                                  suffixIcon: InkWell(
                                    onTap: (){setState(() {
                                      isHiddenConfirm = !isHiddenConfirm;
                                    });},
                                    child: Icon(isHiddenConfirm?Icons.visibility
                                        :Icons.visibility_off),
                                  ),
                                  validator: (value) => (value !=
                                              _passwordController.text
                                                  .toString() ||
                                          value.isEmpty)
                                      ? "يجب تطابق كلمتي السر"
                                      : null,
                                  isPassword: isHiddenConfirm,
                                  controller: _confirmPasswordController,
                                  textInputType: TextInputType.visiblePassword,
                                  label: _strController.confirmPassword,
                                  hintTxt: _strController.confirmPassword),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: myButton(
                            context: context,
                            width: double.infinity,
                            btnTxt: _strController.signUp,
                            fontSize: 20,
                            txtColor: AppColors.whiteColor,
                            radius: 10,
                            btnColor: AppColors.redColor,
                            onPressed: () {
                              _validateAndSubmit();
                            }),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: _strController.hasAccount,
                                    style: appStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: _strController.login,
                                  style: appStyle(
                                      color: AppColors.redColor,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            buildOr(30),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: buildTxt(
                                    txt: _strController.createAccountUsing,
                                    fontSize: 20,
                                    txtColor: AppColors.blackColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildSocialIcons(
                                      width: 40,
                                      height: 40,
                                      borderRadius: 8,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      boxFit: BoxFit.cover,
                                      url: "assets/images/apple.png",
                                    ),
                                    buildSocialIcons(
                                        width: 40,
                                        height: 40,
                                        borderRadius: 8,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        boxFit: BoxFit.cover,
                                        onTap: buildGoogleLogin,
                                        url: "assets/images/google.png"),
                                    buildSocialIcons(
                                        width: 40,
                                        height: 40,
                                        borderRadius: 8,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        boxFit: BoxFit.cover,
                                        onTap: initiateFacebookLogin,
                                        url: "assets/images/facebook.png"),
                                    buildSocialIcons(
                                        width: 40,
                                        height: 40,
                                        borderRadius: 8,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        boxFit: BoxFit.cover,
                                        url: "assets/images/twitter.png"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountriesDialog({MediaQueryData mq}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            title: Center(child: Text(_strController.country)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: mq.size.height * 0.5,
              width: mq.size.width * 1,
              child: ListView.builder(
                itemCount: _countryData.length,
                itemBuilder: (context, index) {
                  final list = _countryData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCountry = list['name'];
                          _myCountry = list['id'].toString();
                          print(_myCountry);
                          _dismissDialog(context: context);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              list['name'],
                              maxLines: 3,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.network(
                                list['flag'],
                                fit: BoxFit.fill,
                                height: 25,
                                width: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        _strController.cancel,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xFF121A21),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }
  _dismissDialog({BuildContext context}) {
    Navigator.pop(context);
  }

  buildGoogleLogin() {
    signInWithGoogle().then((result) {
      if (result != null)
        createAccountFunctionGoogle(
          context: context,
          gId: gId,
          gToken: gToken,
          email: email,
          nickName: _nickNameControllerS.text.toString(),
          userImage: imageUrl,
        ).then((value) {
          if (value == 2095) {
            print('TRY NOW');
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SocialMediaScreen(comeFrom: 'google',countryData: _countryData,noEmail: email.isEmpty,),),);
            // _buildChoiceDialog(noEmail: email.isEmpty, from: 'google');
          }
        });
    });
  }



  var facebookLogin = FacebookLogin();
  var profileData;
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  void initiateFacebookLogin() async {
    facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        {
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');
          print(
              '************************** ${facebookLoginResult.accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());
          onLoginStatusChanged(true, profileData: profile);

          createAccountFunctionFacebook(
            context: context,
            email: profileData['email'],
            // "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
            mobileNumber: "${_phoneControllerS.text.toString()}",
            nickName: "${_nickNameControllerS.text.toString()}",
            fbId: "${facebookLoginResult.accessToken.userId}",
            fbToken: "${facebookLoginResult.accessToken.token}",
            userImage: "${profileData['picture']['data']['url']}",
            mobileCountryIsoCode: mobileCountryIsoCode??'962',
            mobileCountryPhoneCode: mobileCountryPhoneCode.toString(),
            countryId: _myCountry,
          ).then((value) {
            print('VALUE : $value');
            if (value == 2095) {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SocialMediaScreen(comeFrom: 'google',countryData: _countryData,noEmail: email.isEmpty,fId: facebookLoginResult.accessToken.userId.toString(),fToken: facebookLoginResult.accessToken.token,fImage:profileData['picture']['data']['url'],fEmail:profileData['email']),),);
            }
          });
          break;
        }
    }
  }
}

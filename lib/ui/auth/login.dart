import 'dart:convert';
import 'package:bmprogresshud/progresshud.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_string.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/auth/forget_password_screen.dart';
import 'package:kulshe/ui/auth/signup_screen.dart';
import 'package:kulshe/ui/auth/social_media/change_password_social_media.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'social_media/google_login.dart';
import 'package:http/http.dart' as http;

import 'social_media_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController()..text;
  TextEditingController _phoneControllerS = TextEditingController()..text;
  TextEditingController _nickNameControllerS = TextEditingController()..text;
  TextEditingController _passwordController = TextEditingController()..text;
  TextEditingController _mobileCountryCode = TextEditingController()..text;
  TextEditingController mobileCountryIsoCode = TextEditingController()..text;
  String _selectedCountry;
  String _myCountry;
  List _countryData;
  GlobalKey<ProgressHudState> _hudKey = GlobalKey();

  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var facebookLoginResult;

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List countries = jsonDecode(_gp.getString("allCountriesData"));
    _countryData = countries[0]['responseData'];
    setState(() {
      _countryData = _countryData
          .where((element) => element['classified'] == true)
          .toList();
    });

    // print('_${_countryData.where((element) => element['classified'] == true)}');
  }

  void _validateAndSubmit({BuildContext ctx}) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      showLoadingHud(context: ctx,hudKey: _hudKey);
      loginFunction(
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString(),
          context: context).then((value){
        if(value['custom_code'] == 2166){
          _hudKey.currentState?.dismiss();
          setState(() {
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordSocialMedia(value: value['responseData']['token'],),),);
        }else{
          return "";
        }
       });
    } else {
      print('Form is invalid');
    }
  }
  // void _validateDialog() {
  //   final FormState form = _formKey2.currentState;
  //   if (form.validate()) {
  //   } else {
  //     print('Form is invalid');
  //   }
  // }

  @override
  void initState() {
    _selectedCountry = "Select country";
    _getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
         backgroundColor: Colors.grey.shade200,
        body: ProgressHud(
          key: _hudKey,
          isGlobalHud: true,
          child: Directionality(
            textDirection: _drController,

            child: Stack(
              children: [
                buildBg(),
                SingleChildScrollView(
                  child: Container(
                    padding: isLandscape
                        ? EdgeInsets.symmetric(vertical: 20, horizontal: 50)
                        : EdgeInsets.symmetric(horizontal: 15,  vertical: 10),
                    height:
                        isLandscape ? mq.size.height * 1.9 : mq.size.height * 0.9,
                    child: LayoutBuilder(
                      builder: (ctx, constraints) => Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: 'logo',
                              child: buildLogo(height: constraints.maxHeight * 0.2),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: constraints.maxHeight * 0.08,
                              child: buildTxt(
                                  txt: _strController.loginTitle,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  txtColor: AppColors.redColor),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  buildTextField(
                                      controller: _emailController,
                                      label: _strController.email,
                                      textInputType: TextInputType.emailAddress,
                                      validator: validateEmail,
                                      hintTxt: _strController.email),
                                  buildTextField(
                                      validator: validatePassword,
                                      controller: _passwordController,
                                      textInputType: TextInputType.visiblePassword,
                                      label: _strController.password,
                                      isPassword: _passwordHidden,
                                      suffixIcon: InkWell(
                                        onTap: _togglePasswordView,
                                        child: Icon(_passwordHidden?Icons.visibility
                                                    :Icons.visibility_off),
                                      ),
                                      maxLines: 1,
                                      minLines: 1,
                                      hintTxt: _strController.password),
                                ],
                              ),
                            ),
                            Container(
                              height: constraints.maxHeight * 0.05,
                              alignment: AppController.strings is EnglishString
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ForgetPasswordScreen(),)),
                                // no: _strController.cancel,context: ctx,content: buildTextField(label: _strController.email,controller: _emailForgetController),yes: _strController.done,action: ()=>forgetPasswordEmail(context, _emailForgetController.text.toString())),
                                child: buildTxt(
                                    txt: _strController.forgetPassword +" ؟",
                                    txtColor: AppColors.redColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                   ),
                              ),
                            ),
                            //0/05
                            SizedBox(
                              height: 0.03,
                            ),
                            Container(
                              child: myButton(
                                  context: ctx,
                                  height: constraints.maxHeight * 0.07,
                                  width: double.infinity,
                                  btnTxt: _strController.login,
                                  fontSize: 20,
                                  txtColor: AppColors.whiteColor,
                                  radius: 10,
                                  btnColor: AppColors.redColor,
                                  onPressed: () {
                                    _validateAndSubmit(ctx: ctx);
                                    // _showLoadingHud(context);
                                  }),
                            ), //0.07
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              height: constraints.maxHeight * 0.07,
                              width: double.infinity,
                              child: Center(
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                      )),
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: _strController.noAccount,
                                            style: appStyle(
                                                color: AppColors.blackColor2,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                        TextSpan(
                                          text: _strController.signUp,
                                          style: TextStyle(
                                              color: AppColors.redColor,
                                              fontSize: 17,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ), //0.07
                            Container(
                              height: constraints.maxHeight * 0.25,
                              child: Column(
                                children: [
                                  buildOr(
                                    constraints.maxHeight * 0.1,
                                  ),
                                  Container(
                                    height: constraints.maxHeight * 0.05,
                                    child: buildTxt(
                                        txt: _strController.loginUsing,
                                        fontSize: 18,
                                        txtColor: AppColors.blackColor),
                                  ), //0.05
                                  Container(
                                    height: constraints.maxHeight * 0.1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSocialIcons(
                                          width: 45,
                                          height: 45,
                                          borderRadius: 8,
                                          margin:
                                              EdgeInsets.symmetric(horizontal: 8),
                                          boxFit: BoxFit.cover,
                                          url: "assets/images/apple.png",
                                          // onTap: () => Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => SignUp(),
                                          //     ))
                                        ),
                                        buildSocialIcons(
                                            width: 45,
                                            height: 45,
                                            borderRadius: 8,
                                            onTap: () => buildGoogleLogin(),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            boxFit: BoxFit.cover,
                                            url: "assets/images/google.png"),
                                        buildSocialIcons(
                                            width: 45,
                                            height: 45,
                                            borderRadius: 8,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            boxFit: BoxFit.cover,
                                            url: "assets/images/facebook.png",
                                            onTap: () => initiateFacebookLogin()),
                                        buildSocialIcons(
                                            width: 45,
                                            height: 45,
                                            borderRadius: 8,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            boxFit: BoxFit.cover,
                                            url: "assets/images/twitter.png"),
                                      ],
                                    ),
                                  ), //0.1
                                ],
                              ),
                            ),
                            //0.25
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            Navigator.push(context,MaterialPageRoute(builder: (context) => SocialMediaScreen(comeFrom: 'google',countryData: _countryData,noEmail: email.isEmpty,),),);
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
            mobileCountryIsoCode: mobileCountryIsoCode.text.toString(),
            mobileCountryPhoneCode: _mobileCountryCode.text.toString(),
            countryId: _myCountry,
          ).then((value) {
            print('VALUE : $value');
            if (value == 2095) {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SocialMediaScreen(comeFrom: 'facebook',countryData: _countryData,noEmail: profileData['email'].isEmpty,fId: facebookLoginResult.accessToken.userId.toString(),fToken: facebookLoginResult.accessToken.token,fImage:profileData['picture']['data']['url'],fEmail:profileData['email']),),);
              // _buildChoiceDialog(
              //     noEmail: profileData['email'].isEmpty, from: 'facebook');
            }
          });
          break;
        }
    }
  }

bool _passwordHidden = true;
  void _togglePasswordView() {
    setState(() {
      _passwordHidden = !_passwordHidden;
    });
  }
}

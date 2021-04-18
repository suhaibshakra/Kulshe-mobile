import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_string.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/auth/signup_screen.dart';
import 'social_media/google_login.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController()..text;
  TextEditingController _emailControllerS = TextEditingController()..text;
  TextEditingController _phoneControllerS = TextEditingController()..text;
  TextEditingController _nickNameControllerS = TextEditingController()..text;
  TextEditingController _countryControllerS = TextEditingController()..text;
  TextEditingController _emailForgetController = TextEditingController()..text;
  TextEditingController _passwordController = TextEditingController()..text;

  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  void _validateAndSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      loginFunction(
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString(),
          context: context);
    } else {
      print('Form is invalid');
    }
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
          resizeToAvoidBottomInset: false,
          // appBar: buildAppBar(
          //     centerTitle: true,
          //     bgColor: AppColors.whiteColor,
          //     themeColor: Colors.grey),
          // drawer: buildDrawer(context),
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              buildBg(),
              SingleChildScrollView(
                child: Container(
                  padding: isLandscape
                      ? EdgeInsets.symmetric(vertical: 20, horizontal: 50)
                      : EdgeInsets.symmetric(horizontal: 12),
                  height:
                      isLandscape ? mq.size.height * 1.9 : mq.size.height * 0.9,
                  child: LayoutBuilder(
                    builder: (ctx, constraints) => Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLogo(height: constraints.maxHeight * 0.22),
                          Container(
                            height: constraints.maxHeight * 0.08,
                            child: buildTxt(
                                txt: _strController.login,
                                fontSize: 25,
                                txtColor: AppColors.redColor),
                          ),
                          //0.25
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildTextField(
                                    controller: _emailController,
                                    label: _strController.email,
                                    textInputType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        EmailValidator.validate(value)
                                            ? null
                                            : _strController.errorEmail,
                                    hintTxt: _strController.email),
                                buildTextField(
                                    validator: (value) =>
                                        (value.length < 8 || value.isEmpty)
                                            ? _strController.errorPassword
                                            : null,
                                    controller: _passwordController,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    label: _strController.password,
                                    isPassword: true,
                                    hintTxt: _strController.password),
                              ],
                            ),
                          ),
                          //0.25
                          Container(
                            height: constraints.maxHeight * 0.05,
                            alignment: AppController.strings is EnglishString
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => buildDialog(
                                context: ctx,
                                title: AppController.strings.forgetPassword,
                                height: mq.size.height * 0.22,
                                hintTxt: "email@test.com",
                                labelTxt: AppController.strings.email,
                                textInputType: TextInputType.emailAddress,
                                onChanged: (val) {
                                  setState(() {
                                    _emailForgetController = val;
                                  });
                                },
                                controller: _emailForgetController,
                                withToast: true,
                              ),
                              child: buildTxt(
                                  txt: _strController.forgetPassword,
                                  txtColor: AppColors.blue,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
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
                                  _validateAndSubmit();
                                }),
                          ), //0.07
                          Container(
                            padding: EdgeInsets.only(top: 14),
                            height: constraints.maxHeight * 0.05,
                            child: Center(
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    )),
                                child: RichText(
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
    );
  }

  void buildDialog(
      {BuildContext context,
      String title,
      double height,
      TextInputType textInputType,
      String hintTxt,
      String labelTxt,
      String body,
      TextEditingController controller,
      Function onChanged,
      bool withToast = false,
      Function action}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: Colors.black,
                  ),
                  // buildTxt(txt: labelTxt),
                  buildTextField(
                    textInputType: textInputType,
                    hintTxt: hintTxt,
                    label: _strController.email,
                    controller: _emailForgetController,
                    validator: (value) => EmailValidator.validate(value)
                        ? null
                        : "Please enter a valid email",
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "send",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: withToast == true
                                  ? () {
                                      print('BODY:${controller.toString()}');
                                      forgetPasswordEmail(
                                          ctx, controller.text.toString());
                                    }
                                  : action,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false,
        barrierColor: Colors.grey.withOpacity(0.6));
  }

  buildGoogleLogin() {
    signInWithGoogle().then((result) {
      // if (result != null)
      // createAccountFunctionGoogle(
      //   bodyData:
      //       '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "$email",\r\n  "nickName": "Sabaneh!)!)",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n
      //       "mobileNumber": "779712002",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}''',
      //   action: () => showInformationDialog(
      //     context: context,
      //     emailController: _emailControllerS,
      //     nickNameController: _nickNameControllerS,
      //     phoneController: _phoneControllerS,
      //     formKey: _formKey2,
      //     cancel: signOutGoogle(),
      //     onPressed: createAccountFunctionGoogle(
      //       bodyData:
      //           '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "$email",\r\n  "nickName": "Laith",\r\n  "comeFrom": "w",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "779712002",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}''',
      //       // '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "${_emailController.text.toString().trim()}",\r\n  "nickName": "${_nickNameController.text.toString().trim()}",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "${_phoneController.text.toString().trim()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
      //     ),
      //     hasEmail: (_emailControllerS.text.toString() == null ||
      //             _emailControllerS.text.toString() == "")
      //         ? false
      //         : true,
      //   ),
      // );
    });
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out");
  }

  //facebook
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
    var facebookLoginResult = await facebookLogin.logIn(['email']);

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
            email:
                "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
            mobileNumber: "${_phoneControllerS.text.toString()}",
            nickName: "${_nickNameControllerS.text.toString()}",
            fbId: "${facebookLoginResult.accessToken.userId}",
            fbToken: "${facebookLoginResult.accessToken.token}",
            userImage: "${profileData['picture']['data']['url']}",
            mobileCountryIsoCode: "962",
            mobileCountryPhoneCode: "JO",
            countryId: "110",

            // '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "${_emailController.text.toString().trim()}",\r\n  "nickName": "${_nickNameController.text.toString().trim()}",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "${_phoneController.text.toString().trim()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
          ).then((value) {
            print('VALUE : $value');
            value == 2095
                ? showInformationDialog(
                    context: context,
                    formKey: _formKey2,

                    // cancel: _logout(),
                    emailController: _emailControllerS,
                    nickNameController: _nickNameControllerS,
                    phoneController: _phoneControllerS,
                    hasEmail: (profileData['email'] == "" ||
                            profileData['email'] == null)
                        ? false
                        : true,
                    onPressed: () => createAccountFunctionFacebook(
                          email:
                              "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
                          mobileNumber: "${_phoneControllerS.text.toString()}",
                          nickName: "${_nickNameControllerS.text.toString()}",
                          fbId: "${facebookLoginResult.accessToken.userId}",
                          fbToken: "${facebookLoginResult.accessToken.token}",
                          userImage: "${profileData['picture']['data']['url']}",
                          mobileCountryIsoCode: "962",
                          mobileCountryPhoneCode: "JO",
                          countryId: "110",

                          // '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "${_emailController.text.toString().trim()}",\r\n  "nickName": "${_nickNameController.text.toString().trim()}",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "${_phoneController.text.toString().trim()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
                        ))
                : Center();
          });
          // showInformationDialog(
          //   context: context,
          //   emailController: _emailControllerS,
          //   nickNameController: _nickNameControllerS,
          //   phoneController: _phoneControllerS,
          //   formKey: _formKey2,
          //   cancel: ()=>print('Not Done!'),
          //   onPressed:()=> createAccountFunctionFacebook(
          //           email:
          //               "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
          //           mobileNumber: "${_phoneControllerS.text.toString()}",
          //           nickName: "${_nickNameControllerS.text.toString()}",
          //           fbId: "${facebookLoginResult.accessToken.userId}",
          //           fbToken: "${facebookLoginResult.accessToken.token}",
          //           userImage: "${profileData['picture']['data']['url']}",
          //           mobileCountryIsoCode: "962",
          //           mobileCountryPhoneCode: "JO",
          //           countryId: "110",
          //
          //     // '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "${_emailController.text.toString().trim()}",\r\n  "nickName": "${_nickNameController.text.toString().trim()}",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "${_phoneController.text.toString().trim()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
          //   ),
          // );

          // showInformationDialog(
          //     context: context,
          //     cancel: _logout(),
          //     emailController: _emailControllerS,
          //     nickNameController: _nickNameControllerS,
          //     phoneController: _phoneControllerS,
          //     hasEmail:
          //         (profileData['email'] == "" || profileData['email'] == null)
          //             ? false
          //             : true,
          //     onPressed: createAccountFunctionFacebook(
          //       email:
          //           "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
          //       mobileNumber: "${_phoneControllerS.text.toString()}",
          //       nickName: "${_nickNameControllerS.text.toString()}",
          //       fbId: "${facebookLoginResult.accessToken.userId}",
          //       fbToken: "${facebookLoginResult.accessToken.token}",
          //       userImage: "${profileData['picture']['data']['url']}",
          //       mobileCountryIsoCode: "962",
          //       mobileCountryPhoneCode: "JO",
          //       countryId: "110",
          //
          //       // '''{\r\n  "email": ,\r\n  "fbId": ,\r\n  "fbToken": ,\r\n  "nickName": ,\r\n  "comeFrom": "m",\r\n  "userImage": ,\r\n  "mobileNumber": ,\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
          //     ));
          break;
        }
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          "Logged in as: ${profileData['email']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  _displayLoginButton() {
    return RaisedButton(
      child: Text("Login with Facebook"),
      onPressed: () => initiateFacebookLogin(),
    );
  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}

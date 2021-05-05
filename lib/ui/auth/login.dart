import 'dart:convert';

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
import 'package:kulshe/ui/auth/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  TextEditingController _newPasswordController = TextEditingController()..text;
  TextEditingController _confirmPasswordController = TextEditingController()..text;
  TextEditingController _mobileCountryCode = TextEditingController()..text;
  TextEditingController mobileCountryIsoCode = TextEditingController()..text;
  String _selectedCountry;
  String _myCountry;
  List _countryData;

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

    print('_${_countryData.where((element) => element['classified'] == true)}');
  }

  void _validateAndSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      loginFunction(
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString(),
          context: context).then((value){
        print('VAL:$value');
        if(value['custom_code'] == 2166){
              buildDialog(desc: '',no: _strController.cancel,yes: _strController.done,title: "Enter New Password", context: context,content: Column(
                children: [
                  buildTextField(
                    fromDialog: true,
                    label: _strController.newPassword,
                    controller: _newPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    isPassword: true
                  ),
                  buildTextField(
                    fromDialog: true,
                    label: _strController.confirmPassword,
                    controller: _confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    isPassword: true
                  ),
                ],
              ),
                action:()=> changePasswordSocial(context, _newPasswordController.text.toString(), _confirmPasswordController.text.toString(),value['responseData']['token'].toString()).then((value) {
                  print('VALUE');
                  print(value['responseData']['token']);

                  })
              );
            }
      });
    } else {
      print('Form is invalid');
    }
  }
  void _validateDialog() {
    final FormState form = _formKey2.currentState;
    if (form.validate()) {
    } else {
      print('Form is invalid');
    }
  }

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
                      : EdgeInsets.symmetric(horizontal: 25,vertical: 40),
                  height:
                      isLandscape ? mq.size.height * 1.9 : mq.size.height * 0.9,
                  child: LayoutBuilder(
                    builder: (ctx, constraints) => Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLogo(height: constraints.maxHeight * 0.2),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: constraints.maxHeight * 0.08,
                            child: buildTxt(
                                txt: _strController.loginTitle,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
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
                                    maxLines: 1,
                                    minLines: 1,
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
                              onTap: () => buildDialog(title: 'استرجاع كلمة السر',
                              no: _strController.cancel,context: ctx,content: buildTextField(label: _strController.email,controller: _emailForgetController),yes: _strController.done,action: ()=>forgetPasswordEmail(context, _emailForgetController.text.toString())),
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

  void _buildDialog({BuildContext context,String title,double height,TextInputType textInputType,String hintTxt,String labelTxt,String body,TextEditingController controller,Function onChanged,bool withToast = false,Function action}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // buildTxt(txt: labelTxt),
                  buildTextField(
                    textInputType: textInputType,
                    hintTxt: hintTxt,
                    label: _strController.email,
                    onChanged: (val){
                      setState(() {
                        _emailForgetController.text = val;
                      });
                    }
                    // validator: (value) => EmailValidator.validate(value)
                    //     ? null
                    //     : "Please enter a valid email",
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
            _buildChoiceDialog(noEmail: email.isEmpty, from: 'google');
          }
        });
    });
  }

  _buildChoiceDialog({bool noEmail, String from}) {
    return buildDialog(
        context: context,
        title: "يرجى إدخال الحقول المطلوبة",
        desc: "",
        no: _strController.cancel,
        yes: _strController.done,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: myButton(
                  txtColor: AppColors.blackColor,
                  fontSize: 18,
                  context: context,
                  btnColor: AppColors.greyOne,
                  radius: 4,
                  btnTxt: _selectedCountry,
                  width: double.infinity,
                  onPressed: () =>
                      _showCountriesDialog(mq: MediaQuery.of(context))),
            ),
            buildTextField(
              label: _strController.nickName,
              controller: _nickNameControllerS,
              textInputType: TextInputType.name,
            ),
            if (noEmail)
              buildTextField(
                label: _strController.email,
                controller: _emailControllerS,
                textInputType: TextInputType.emailAddress,
              ),
            Row(
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
                          isShowFlag: false,
                          isShowTitle: false,
                          isShowCode: true,
                          isDownIcon: false,
                          showEnglishName: true,
                          initialSelection: '+962'),
                      initialSelection: '+962',
                      useSafeArea: true,
                      onChanged: (CountryCode code) {
                        print(code.name);
                        print(code.code);
                        print(code.dialCode);
                        print(code.dialCode);
                        print(code.dialCode);
                        print(code.flagUri);
                        setState(() {
                          mobileCountryIsoCode.text = code.code;
                          _mobileCountryCode.text =
                              code.dialCode.replaceAll('+', '').toString();
                          print('code : ${_mobileCountryCode.text}');
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: buildTextField(
                    fromDialog: true,
                    label: _strController.mobile,
                    controller: _phoneControllerS,
                    hintTxt: _strController.mobile,
                    textInputType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ],
        ),
        action: () => from == 'google'
            ? createAccountFunctionGoogle(
                    context: context,
                    gId: gId,
                    gToken: gToken,
                    email: email,
                    nickName: _nickNameControllerS.text.toString(),
                    userImage: imageUrl,
                    countryId: _myCountry.toString(),
                    mobileCountryIsoCode: mobileCountryIsoCode.text.isEmpty
                        ? '962'
                        : mobileCountryIsoCode.text.toString(),
                    mobileNumber: _phoneControllerS.text.toString(),
                    mobileCountryPhoneCode: _mobileCountryCode.text.toString())
                .then((value) {
                if (value == 200)
                  Navigator.of(context, rootNavigator: true).pop();
              })
            : from == 'facebook'
                ? createAccountFunctionFacebook(
                        context: context,
                        email:
                            "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
                        mobileNumber: "${_phoneControllerS.text.toString()}",
                        nickName: "${_nickNameControllerS.text.toString()}",
                        fbId: "${facebookLoginResult.accessToken.userId}",
                        fbToken: "${facebookLoginResult.accessToken.token}",
                        userImage: "${profileData['picture']['data']['url']}",
                        mobileCountryIsoCode: mobileCountryIsoCode.text.isEmpty
                            ? '962'
                            : mobileCountryIsoCode.text.toString(),
                        mobileCountryPhoneCode:
                            _mobileCountryCode.text.toString(),
                        countryId: _myCountry.toString()

                        // '''{\r\n  "googleId": "$gId",\r\n  "googleToken": "$gToken",\r\n  "email": "${_emailController.text.toString().trim()}",\r\n  "nickName": "${_nickNameController.text.toString().trim()}",\r\n  "comeFrom": "m",\r\n  "userImage": "https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg",\r\n  "mobileNumber": "${_phoneController.text.toString().trim()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
                        )
                    .then((value) {
                    if (value == 200)
                      Navigator.of(context, rootNavigator: true).pop();
                  })
                : null);
  }

  // Future<void> signOutGoogle() async {
  //   await googleSignIn.signOut();
  //   print("User Signed Out");
  // }

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
              _buildChoiceDialog(
                  noEmail: profileData['email'].isEmpty, from: 'facebook');
            }
          });
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
                    width: MediaQuery.of(context).size.width * 0.16,
                    child: RaisedButton(
                      child: new Text(
                        'Fund',
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
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: RaisedButton(
                        child: new Text(
                          'Cancel',
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
}

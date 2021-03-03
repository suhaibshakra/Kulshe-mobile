import 'package:flutter/material.dart';
import '../api/api.dart';
import '../auth/sign_up.dart';
import '../utilities/app_helpers/app_controller.dart';
import '../utilities/app_helpers/app_style.dart';
import '../utilities/app_helpers/my_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../nav_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _email = "";
  var _password = "";
  var _emailFB = "";
  bool remember = false;

  String token;
  String refreshToken;

  getTokens() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      token = _preferences.getString('token');
      refreshToken = _preferences.getString('refresh_token');
      print("TOKEN  :  $token");
    });
  }

  viewAction() {
    token != null
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavPage(),
            ),
          )
        : print('NO');
  }

  @override
  void initState() {
    getTokens().then((value){viewAction();});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              buildBg(),
              ListView(
                children: [
                  buildHeader(),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      //email
                      buildLabel(txt: AppController.strings.email),
                      buildTextField(
                          textInputType: TextInputType.emailAddress,
                          hintTxt: "name@domain.com",
                          onChanged: (val) {
                            setState(() {
                              _email = val;
                            });
                          }),
                      //password
                      buildLabel(txt: AppController.strings.password),
                      SizedBox(
                        height: 6,
                      ),
                      buildTextFieldPsw(
                          textInputType: TextInputType.visiblePassword,
                          onChanged: (val) {
                            setState(() {
                              _password = val;
                            });
                          }),
                      //forget password
                      buildForgetPsw(context),
                    ],
                  ),
                  buildLoginBtn(),
                  // buildCheckBox(),
                  Container(
                    child: Column(
                      children: [
                        buildRowOr(),
                        Text(
                          "Login Using",
                          style: AppStyle.textStyleBasic),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                                child: buildSocialIcons("assets/images/apple.png")),
                            buildSocialIcons("assets/images/google.png"),
                            buildSocialIcons("assets/images/twitter.png"),
                            buildSocialIcons("assets/images/facebook.png"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO:CHECKBOX
  // Widget buildCheckBox() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 25),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Row(
  //           children: [
  //             Checkbox(
  //               value: remember,
  //               onChanged: (value) {
  //                 setState(() {
  //                   remember = value;
  //                 });
  //                 print('remember ? $remember');
  //               },
  //             ),
  //             Text("Remember Me"),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildRowOr() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                color: Colors.black26,
                height: 1,
              )),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            AppController.strings.or,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(
                color: Colors.black26,
                height: 1,
              )),
        ),
      ]),
    );
  }

  Widget buildForgetPsw(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              buildDialog(
                context: ctx,
                title: AppController.strings.forgotPassword,
                height: 200,
                hintTxt: "email@test.com",
                labelTxt: AppController.strings.email,
                textInputType: TextInputType.emailAddress,
                onChanged: (val) {
                  setState(() {
                    _emailFB = val;
                  });
                },
                controller: _emailFB,
                withToast: true,
              );
            },
            child: Text(
              AppController.strings.forgotPassword,
              style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: buildMainButton(
          btnColor: Colors.red.shade400,
          radius: 6,
          txt: AppController.strings.login,
          txtColor: Colors.white,
          onPressedBtn: () {
            print('Login Pressed');
            loginFunction(
                email: _email.toString(),
                password: _password.toString(),
                context: context);
          }),
    );
  }

  // Widget buildLabel({String txt}) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 6),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 2.0),
  //       child: Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             txt,
  //             style:
  //                 TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           )),
  //     ),
  //   );
  // }

  Widget buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 70.0,
          backgroundImage:
          AssetImage('assets/images/logo_icon.png'),
          backgroundColor: Colors.transparent,
        ),
        buildLabel(txt: AppController.strings.login,style: AppStyle.textStyleLabelMain,alignment: Alignment.center)
      ],
    );
  }

  Container buildSocialIcons(String url) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

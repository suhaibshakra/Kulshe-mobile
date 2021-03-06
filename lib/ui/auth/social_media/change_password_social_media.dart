import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_string.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/auth/login.dart';
import 'package:kulshe/ui/auth/social_media/google_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordSocialMedia extends StatefulWidget {
  final value;

  const ChangePasswordSocialMedia({Key key, this.value}) : super(key: key);
  @override
  _ChangePasswordSocialMediaState createState() => _ChangePasswordSocialMediaState();
}

class _ChangePasswordSocialMediaState extends State<ChangePasswordSocialMedia> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  
  final _strController = AppController.strings;
  bool isHiddenNew = true;
  bool isHiddenConfirm = true;

  final GlobalKey<FormState> _formKeyChangePassword = GlobalKey<FormState>();

  void _validateAndSubmit() {
    final FormState form = _formKeyChangePassword.currentState;
    if (form.validate()) {
      // print(widget.value);
      changePasswordSocial(context, _newPasswordController.text.toString(), _confirmPasswordController.text.toString(),widget.value.toString());
    } else {
      print('Form is invalid');
    }
  }
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Directionality(
          textDirection: AppController.textDirection,
          child: Stack(
            children: [
              buildBg(),
              SingleChildScrollView(
                child: Container(
                  padding: isLandscape
                      ? EdgeInsets.symmetric(vertical: 20, horizontal: 50)
                      : EdgeInsets.symmetric(horizontal: 15),
                  height:
                  isLandscape ? mq.size.height * 1.9 : mq.size.height * 0.8,
                  child:  Form(
                    key: _formKeyChangePassword,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: buildLogo(height: mq.size.height*0.2),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: mq.size.height*0.08,
                          child: buildTxt(
                              txt: _strController.changePassword,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              txtColor: AppColors.redColor),
                        ),
                        Column(
                          children: [
                            Container(
                              child: buildTextField(
                                label: _strController.newPassword,
                                controller: _newPasswordController,
                                isPassword: isHiddenNew,
                                suffixIcon: InkWell(
                                  onTap: (){setState(() {
                                    isHiddenNew = !isHiddenNew;
                                  });},
                                  child: Icon(isHiddenNew?Icons.visibility
                                      :Icons.visibility_off),
                                ),
                                textInputType: TextInputType.visiblePassword,
                                validator: (value) =>
                                (value.isEmpty)?
                                "???????? ???????????? ?????? ??????????" :
                                (value.length < 8)
                                    ? "?????? ???? ???? ?????? ???? 8 ????????"
                                    : null,
                              ),
                            ),
                            SizedBox(height: 20,),
                              Container(
                                child: buildTextField(
                                    controller: _confirmPasswordController,
                                    label: _strController.confirmPassword,
                                  isPassword: isHiddenConfirm,
                                  suffixIcon: InkWell(
                                    onTap: (){setState(() {
                                      isHiddenConfirm = !isHiddenConfirm;
                                    });},
                                    child: Icon(isHiddenConfirm?Icons.visibility
                                        :Icons.visibility_off),
                                  ),
                                  textInputType: TextInputType.emailAddress,
                                    validator: (value) =>
                                    (value.isEmpty)?
                                    "???????? ???????????? ?????? ??????????" :
                                    (value != _newPasswordController.text
                                            .toString() ||
                                        value.isEmpty)
                                        ? "?????? ?????????? ?????????? ????????"
                                        : null,
                                ),
                              ),
                              SizedBox(height: 20,),
                            Container(
                              child: myButton(
                                  context: context,
                                  height: mq.size.height*0.06,
                                  width: double.infinity,
                                  btnTxt: _strController.done,
                                  fontSize: 20,
                                  txtColor: AppColors.whiteColor,
                                  radius: 10,
                                  btnColor: AppColors.redColor,
                                  onPressed: () {
                                    _validateAndSubmit();
                                  }),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: mq.size.height*0.06,
                          child: Center(
                            child: InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  )),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: _strController.hasAccount,
                                        style: appStyle(
                                            color: AppColors.blackColor2,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700)),
                                    TextSpan(
                                      text: _strController.login,
                                      style: TextStyle(
                                          color: AppColors.redColor,
                                          fontSize: 18,
                                          decoration:
                                          TextDecoration.underline,
                                          fontWeight: FontWeight.w700),
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
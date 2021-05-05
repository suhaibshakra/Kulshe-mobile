import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_string.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/auth/login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _resetPassword = TextEditingController();
  final _strController = AppController.strings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      forgetPasswordEmail(context, _resetPassword.text.toString());
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
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildLogo(height: mq.size.height*0.2),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: mq.size.height*0.08,
                            child: buildTxt(
                                txt: _strController.resetPassword,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                txtColor: AppColors.redColor),
                          ),
                          Column(
                            children: [
                              Container(
                                child: buildTextField(
                                    controller: _resetPassword,
                                    label: _strController.email,
                                    textInputType: TextInputType.emailAddress,
                                    validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : _strController.errorEmail,
                                    hintTxt: _strController.email),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                child: myButton(
                                    context: context,
                                    height: mq.size.height*0.06,
                                    width: double.infinity,
                                    btnTxt: _strController.sendAnEmail,
                                    fontSize: 20,
                                    txtColor: AppColors.whiteColor,
                                    radius: 10,
                                    btnColor: AppColors.redColor,
                                    onPressed: () {
                                      _validateAndSubmit();
                                      // forgetPasswordEmail(context, _emailForgetController.text.toString()
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
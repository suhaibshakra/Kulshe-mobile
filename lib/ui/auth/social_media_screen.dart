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

class SocialMediaScreen extends StatefulWidget {
  final bool noEmail;
  final String comeFrom;
  final String fId;
  final String fToken;
  final String fImage;
  final String fEmail;
  final List countryData;

  const SocialMediaScreen({Key key, this.noEmail, this.comeFrom,this.countryData, this.fId, this.fToken, this.fImage, this.fEmail}) : super(key: key);
  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _mobileCountryCode = TextEditingController();
  TextEditingController mobileCountryIsoCode = TextEditingController();
  TextEditingController _phoneController = TextEditingController()..text;
  String _selectedCountry = AppController.strings.selectCountry;
  String _myCountry;
  final _strController = AppController.strings;
  final GlobalKey<FormState> _formKeySocial = GlobalKey<FormState>();

  void _validateAndSubmit() {
    final FormState form = _formKeySocial.currentState;
    if (form.validate()) {
      if(widget.comeFrom == 'google')
        createAccountFunctionGoogle(
            context: context,
            gId: gId,
            gToken: gToken,
            email: email,
            nickName: _nickNameController.text.toString(),
            userImage: imageUrl,
            countryId: _myCountry.toString(),
            mobileCountryIsoCode: mobileCountryIsoCode.text.isEmpty? 'JO': mobileCountryIsoCode.text.toString(),
            mobileNumber: _phoneController.text.toString(),
            mobileCountryPhoneCode: _mobileCountryCode.text.isEmpty?"962":_mobileCountryCode.text.toString());

      if(widget.comeFrom == 'facebook')
        createAccountFunctionFacebook(
          context: context,
          email: widget.fEmail,
          // "${(profileData['email'] == "" || profileData['email'] == null) ? _emailControllerS.text.toString() : profileData['email']}",
          mobileNumber: "${_phoneController.text.toString()}",
          nickName: "${_nickNameController.text.toString()}",
          fbId: "${widget.fId}",
          fbToken: "${widget.fToken}",
          userImage: "${widget.fImage}",
          mobileCountryIsoCode: mobileCountryIsoCode.text.isEmpty? 'JO': mobileCountryIsoCode.text.toString(),
            mobileCountryPhoneCode: _mobileCountryCode.text.isEmpty?"962":_mobileCountryCode.text.toString(),
          countryId: _myCountry,
        );
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
                      key: _formKeySocial,
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
                                txt: _strController.enterRequiredField,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                txtColor: AppColors.redColor),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8, left: 5, right: 5),
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
                              SizedBox(height: 20,),
                              Container(
                                child: buildTextField(
                                  label: _strController.nickName,
                                  controller: _nickNameController,
                                  textInputType: TextInputType.name,
                                    validator: (value) =>
                                    (value.length < 3 || value.isEmpty)
                                        ? "الحد الأدنى 3 احرف"
                                        : null,
                                 ),
                              ),
                                SizedBox(height: 20,),
                              if(widget.noEmail)
                                Container(
                                  child: buildTextField(
                                      controller: _emailController,
                                      label: _strController.email,
                                      textInputType: TextInputType.emailAddress,
                                      validator: (value) =>
                                      EmailValidator.validate(value)
                                          ? null
                                          : _strController.errorEmail,
                                      hintTxt: _strController.email),
                                ),
                              if(widget.noEmail)
                                SizedBox(height: 20,),
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
                                            isShowFlag: true,
                                            isShowTitle: false,
                                            isShowCode: true,
                                            isDownIcon: false,
                                            showEnglishName: false,
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
                                            print('code : ${_mobileCountryCode.text}');//962
                                            print('iso : ${mobileCountryIsoCode.text}');//jo
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: buildTextField(
                                      fromDialog: true,
                                      label: _strController.mobile,
                                      controller: _phoneController,
                                      validator: (value) =>
                                      (value.length > 11 ||
                                          value.length < 9 ||
                                          value.isEmpty)
                                          ? "أدخل رقم صحيح"
                                          : null,
                                      hintTxt: _strController.mobile,
                                      textInputType: TextInputType.phone,
                                    ),
                                  ),
                                ],
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
                itemCount: widget.countryData.length,
                itemBuilder: (context, index) {
                  final list = widget.countryData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCountry = list['name'];
                          _myCountry = list['id'].toString();
                          print(_myCountry);
                          Navigator.pop(context);
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

}
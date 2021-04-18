import 'dart:convert';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _countryController = TextEditingController()..text;
  TextEditingController _nickNameController = TextEditingController()..text;
  TextEditingController _emailController = TextEditingController()..text;
  TextEditingController _phoneController = TextEditingController()..text;
  TextEditingController _passwordController = TextEditingController()..text;
  TextEditingController _confirmPasswordController = TextEditingController()
    ..text;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedCountry;

  String _myCountry;

  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  String mobileCountryPhoneCode = "";
  String mobileCountryIsoCode = "";

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
      _selectedCountry = "Select country";
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
          appBar: buildAppBar(
              centerTitle: true,
              bgColor: AppColors.whiteColor,
              themeColor: Colors.grey),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              buildBg(),
              SingleChildScrollView(
                child: Container(
                  padding: isLandscape
                      ? EdgeInsets.symmetric(vertical: 20, horizontal: 50)
                      : EdgeInsets.symmetric(horizontal: 8),
                  height:
                      isLandscape ? mq.size.height * 1.5 : mq.size.height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: buildTxt(
                            txt: _strController.createAccount,
                            fontSize: 25,
                            txtColor: AppColors.redColor),
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 8, left: 12, right: 12),
                                child: myButton(
                                    txtColor: AppColors.blackColor,
                                    fontSize: 18,
                                    context: context,
                                    btnColor: AppColors.greyOne,
                                    radius: 4,
                                    btnTxt: _selectedCountry,
                                    width: double.infinity,
                                    onPressed: () =>
                                        _showCountriesDialog(mq: mq)),
                              ),
                              buildTextField(
                                label: _strController.nickName,
                                hintTxt: "Enter Name",
                                controller: _nickNameController,
                                textInputType: TextInputType.name,
                                validator: (value) =>
                                    (value.length < 3 || value.isEmpty)
                                        ? "Enter Valid Name"
                                        : null,
                              ),
                              buildTextField(
                                label: _strController.email,
                                hintTxt: "Email Address",
                                textInputType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "Please enter a valid email",
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
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: AppColors
                                                              .whiteColor
                                                              .withOpacity(0.4),
                                                          offset: Offset(1, 2),
                                                          blurRadius: 2,
                                                          spreadRadius: 1),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: CountryListPick(
                                                  appBar: AppBar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    title: Text(
                                                      "Country",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor),
                                                    ),
                                                  ),
                                                  theme: CountryTheme(
                                                      isShowFlag: true,
                                                      isShowTitle: false,
                                                      isShowCode: true,
                                                      isDownIcon: false,
                                                      showEnglishName: true,
                                                      initialSelection: '+962'),
                                                  initialSelection: '+962',
                                                  useSafeArea: true,
                                                  onChanged:
                                                      (CountryCode code) {
                                                    setState(() {
                                                      mobileCountryIsoCode =
                                                          code.code;
                                                      mobileCountryPhoneCode =
                                                          code.dialCode
                                                              .replaceAll(
                                                                  '+', '')
                                                              .toString();
                                                      print(
                                                          'code : $mobileCountryPhoneCode');
                                                    });
                                                  },
                                                ),
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
                                                        ? "Enter valid number"
                                                        : null,
                                                controller: _phoneController,
                                                textInputType:
                                                    TextInputType.phone,
                                                label: _strController.mobile,
                                                hintTxt: "Enter phone number"),
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
                                          ? "Password must match"
                                          : null,
                                  controller: _passwordController,
                                  textInputType: TextInputType.visiblePassword,
                                  label: _strController.password,
                                  hintTxt: "Password"),
                              buildTextField(
                                  validator: (value) => (value !=
                                              _passwordController.text
                                                  .toString() ||
                                          value.isEmpty)
                                      ? "Password must match"
                                      : null,
                                  controller: _confirmPasswordController,
                                  textInputType: TextInputType.visiblePassword,
                                  label: _strController.confirmPassword,
                                  hintTxt: "Confirm Password"),
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
                                        url: "assets/images/google.png"),
                                    buildSocialIcons(
                                        width: 40,
                                        height: 40,
                                        borderRadius: 8,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        boxFit: BoxFit.cover,
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

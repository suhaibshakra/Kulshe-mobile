import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/models/profile.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  // final ResponseProfileData profileData;

  // EditProfileScreen({@required this.profileData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;

  var currentStat;
  TextEditingController _nickName = TextEditingController()..text;
  TextEditingController _fullName = TextEditingController()..text;
  int _myCountry;

  TextEditingController _mobile = TextEditingController()..text;
  TextEditingController _email = TextEditingController()..text;
  TextEditingController _oldPassword = TextEditingController()..text;
  TextEditingController _newPassword = TextEditingController()..text;
  TextEditingController _confirmPassword = TextEditingController()..text;
  TextEditingController _mobileCountryCode = TextEditingController()..text;
  TextEditingController mobileCountryIsoCode = TextEditingController()..text;
  TextEditingController additionalPhoneNumber = TextEditingController()..text;
  TextEditingController additionalPhoneCountryIsoCode = TextEditingController()
    ..text;
  TextEditingController additionalPhoneCountryCode = TextEditingController()
    ..text;
  TextEditingController currentLang;

  bool _newsletter;
  bool _promotion;
  bool _showContactInfo;

  var appController = AppController.strings;
  String _selectedCountry = "Select country";
  List lastProfileData;
  final ImagePicker _picker = ImagePicker();
  List _countryData;
  File _userImageFile;
  var bytes;
  File _pickedImage;
  var _userImage;
  var _imgURL;
  bool _loading = true;
  List<Widget> listOfAdsTypes = [];

  void _pickImageLast(ImageSource src) async {
    final pickedImageFile =
    await _picker.getImage(source: src, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      _userImageFile = _pickedImage;
      bytes = File(_userImageFile.path).readAsBytesSync();

      String fileName = _userImageFile.path.split('/').last;
      fileName = fileName.split('.').last;

      print(fileName);
      print("data:image/$fileName;base64,${base64Encode(bytes)}");
      _userImage = "data:image/$fileName;base64,${base64Encode(bytes)}";
    } else {
      print('No Image Selected');
    }
  }

  ResponseProfileData _profileData;
  List<Widget> _txtFieldList = [];

  _getCountries() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections = jsonDecode(_gp.getString("allCountriesData"));
    _countryData = sections[0]['responseData'];
    setState(() {
      _countryData = _countryData
          .where((element) => element['classified'] == true)
          .toList();
    });
    // print(sections[0].responseData[4].name);
  }

  @override
  void initState() {
    _getCountries();
    ProfileServicesNew.getProfileData().then((profileData) {
      setState(() {
        lastProfileData = profileData;
        _myCountry = profileData[0]['responseData']['country_id'];
        _selectedCountry = profileData[0]['responseData']['country']['name'];
        _nickName.text = profileData[0]['responseData']['nick_name'];
        _fullName.text = profileData[0]['responseData']['full_name'];
        _email.text = profileData[0]['responseData']['email'];
        _mobile.text = profileData[0]['responseData']['mobile_number'];
        _mobileCountryCode.text = profileData[0]['responseData']['mobile_country_code'];
        mobileCountryIsoCode.text =
            profileData[0]['responseData']['mobile_country_iso_code'];
        _newsletter = profileData[0]['responseData']['newsletter'];
        _promotion = profileData[0]['responseData']['promotions'];
        _showContactInfo = profileData[0]['responseData']['show_contact_info'];
        _imgURL = profileData[0]['responseData']['profile_image'];
        additionalPhoneNumber.text =
            profileData[0]['responseData']['additional_phone_number'];
        additionalPhoneCountryIsoCode.text =
            profileData[0]['responseData']['additional_phone_country_iso_code'];
        additionalPhoneCountryCode.text =
            profileData[0]['responseData']['additional_phone_country_code'];

        _loading = false;

        // print(additionalPhoneCountryCode);
        // print(additionalPhoneNumber);
        // print(additionalPhoneCountryIsoCode);
        // print(_promotion);
        // print(_showContactInfo);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    setState(() {
      _txtFieldList = [];
    });

    double height = mq.size.height * 0.2;
    return Directionality(
      textDirection: _drController,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: _loading
                ? Center(child: buildLoading(color: AppColors.green))
                : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent.shade400,
                          Colors.lightBlueAccent.shade200,
                          Colors.lightBlueAccent.shade200,
                          Colors.lightBlueAccent.shade200,
                          Colors.lightBlueAccent.shade400,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    height: isLandscape
                        ? mq.size.height * 0.3
                        : mq.size.height * 0.22,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage)
                              : NetworkImage("$_imgURL"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            buildIconWithTxt(
                              iconData: Icons.camera,
                              iconColor: AppColors.whiteColor,
                              label: Text(_strController.labelCamera,style: appStyle(fontSize: 16,color: AppColors.whiteColor,fontWeight: FontWeight.w400),),
                              action: () =>
                                  _pickImageLast(ImageSource.camera),
                            ),
                            buildIconWithTxt(
                              iconData: Icons.image_outlined,
                              iconColor: AppColors.whiteColor,
                              label: Text(_strController.labelGallery,style: appStyle(fontSize: 16,color: AppColors.whiteColor,fontWeight: FontWeight.w400),),
                              action: () =>
                                  _pickImageLast(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  _showTestDialog();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_selectedCountry),
                                    buildIconWithTxt(
                                        iconData: Icons.flag,
                                        label: Text(""))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                              child: buildTextField(
                                hintTxt: _nickName.text.toString() != ""
                                    ? _nickName.text.toString()
                                    : appController.nickName,
                                textInputType: TextInputType.name,
                                label: appController.nickName,
                                controller: _nickName,
                                fromPhone: true,
                                validator: (value) =>
                                (value.length < 3 || value.isEmpty)
                                    ? "Enter Valid Name"
                                    : null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                                child: buildTextField(
                                  hintTxt: _fullName.text.toString() != ""
                                      ? _fullName.text.toString()
                                      : appController.fullName,
                                  textInputType: TextInputType.name,
                                  label: appController.fullName,
                                  controller: _fullName,
                                  fromPhone: true,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                               child: buildTextField(
                                label: _strController.email,
                                hintTxt: _email.text.toString() != ""
                                    ? _email.text.toString()
                                    : appController.email,
                                textInputType: TextInputType.emailAddress,
                                controller: _email,
                                fromPhone: true,
                                validator: (value) =>
                                EmailValidator.validate(value)
                                    ? null
                                    : "Please enter a valid email",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white
                                              .withOpacity(0.6),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      child: CountryListPick(
                                        appBar: AppBar(
                                          backgroundColor: Colors.blue,
                                          title: Text(
                                              _strController.country,
                                          style: appStyle(fontSize: 18,fontWeight: FontWeight.w400),),
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
                                        onChanged: (CountryCode code) {
                                          print(code.name);
                                          print(code.code);
                                          print(code.dialCode);
                                          print(code.dialCode);
                                          print(code.dialCode);
                                          print(code.flagUri);
                                          setState(() {
                                            mobileCountryIsoCode.text =
                                                code.code;
                                            _mobileCountryCode.text = code
                                                .dialCode
                                                .replaceAll('+', '')
                                                .toString();
                                            print(
                                                'code : ${_mobileCountryCode.text}');
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: buildTextField(
                                        hintTxt:
                                        _mobile.text.toString() != ""
                                            ? _mobile.text.toString()
                                            : "79XXXXXXX",
                                        textInputType:
                                        TextInputType.phone,
                                        fromPhone: true,
                                        controller: _mobile,
                                        label: _strController.mobile),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white
                                              .withOpacity(0.6),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey),
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      child: CountryListPick(
                                        appBar: AppBar(
                                          backgroundColor: Colors.blue,
                                          title: Text("Country"),
                                        ),
                                        theme: CountryTheme(
                                            isShowFlag: true,
                                            isShowTitle: false,
                                            isShowCode: true,
                                            isDownIcon: false,
                                            showEnglishName: true,
                                            initialSelection:
                                            '+${additionalPhoneCountryCode.text}'),
                                        initialSelection:
                                        '+${additionalPhoneCountryCode.text}',
                                        useSafeArea: true,
                                        onChanged: (CountryCode code) {
                                          print(code.name);
                                          print(code.code);
                                          print(code.dialCode);
                                          print(code.dialCode);
                                          print(code.dialCode);
                                          print(code.flagUri);
                                          setState(() {
                                            additionalPhoneCountryIsoCode
                                                .text = code.code;
                                            additionalPhoneCountryCode
                                                .text =
                                                code.dialCode
                                                    .replaceAll('+', '')
                                                    .toString();
                                            print(
                                                'code : ${additionalPhoneCountryCode.text}');
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: buildTextField(
                                        hintTxt: additionalPhoneNumber
                                            .text
                                            .toString() !=
                                            ""
                                            ? additionalPhoneNumber.text
                                            .toString()
                                            : _strController
                                            .additionalMobile,
                                        textInputType:
                                        TextInputType.phone,
                                        fromPhone: true,
                                        controller: additionalPhoneNumber,
                                        label: _strController
                                            .additionalMobile),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                               child: buildTextField(
                                  hintTxt: _strController.oldPassword,
                                  textInputType:
                                  TextInputType.visiblePassword,
                                  controller: _oldPassword,
                                  fromPhone: true,
                                  label: _strController.oldPassword),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                               child: buildTextField(
                                  hintTxt: _strController.newPassword,
                                  textInputType:
                                  TextInputType.visiblePassword,
                                  controller: _newPassword,
                                  fromPhone: true,
                                  label: _strController.newPassword),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Container(
                               child: buildTextField(
                                  hintTxt: _strController.conPassword,
                                  fromPhone: true,
                                  textInputType:
                                  TextInputType.visiblePassword,
                                  label: _strController.conPassword,
                                  controller: _confirmPassword),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: MergeSemantics(
                              child: ListTile(
                                title: Text(_strController.news,style:appStyle(fontSize: 16,color: AppColors.blackColor2),),
                                trailing: CupertinoSwitch(
                                  value: _newsletter,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _newsletter = value;
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _newsletter = !_newsletter;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: MergeSemantics(
                              child: ListTile(
                                title: Text(_strController.promotion,style:appStyle(fontSize: 16,color: AppColors.blackColor2),),
                                trailing: CupertinoSwitch(
                                  value: _promotion,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _promotion = value;
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _promotion = !_promotion;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: MergeSemantics(
                              child: ListTile(
                                title:
                                Text(_strController.showContactInfo,style: appStyle(fontSize: 16,color: AppColors.blackColor2),),
                                trailing: CupertinoSwitch(
                                  value: _showContactInfo,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _showContactInfo = value;
                                      print('SHOW~:$_showContactInfo');
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _showContactInfo = !_showContactInfo;
                                    print('SHOW~:$_showContactInfo');
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
                            child: Container(
                              child: myButton(
                                fontSize: 18,
                                txtColor: AppColors.whiteColor,
                                width: double.infinity,
                                radius: 10,
                                btnTxt: _strController.editProfile,
                                btnColor: AppColors.blue,
                                context: context,
                                onPressed: () {
                                  updateProfile(
                                      context: context,
                                      countryId: _myCountry.toString(),
                                      nickName: _nickName.text.toString(),
                                      fullName: _fullName.text.toString(),
                                      email: _email.text.toString(),
                                      mobileNumber:
                                      _mobile.text.toString(),
                                      mobileCountryIsoCode:
                                      mobileCountryIsoCode.text
                                          .toString(),
                                      mobileCountryCode:
                                      _mobileCountryCode.text
                                          .toString(),
                                      oldPassword:
                                      _oldPassword.text.toString(),
                                      newPassword:
                                      _newPassword.text.toString(),
                                      confirmPassword: _confirmPassword
                                          .text
                                          .toString(),
                                      newsLetter: _newsletter ,
                                      promotions: _promotion ,
                                      showContactInfo: _showContactInfo ,
                                      additionalPhoneCountryCode:
                                      additionalPhoneCountryCode.text
                                          .toString(),
                                      additionalPhoneCountryIsoCode:
                                      additionalPhoneCountryIsoCode
                                          .text
                                          .toString(),
                                      additionalPhoneNumber:
                                      additionalPhoneNumber.text
                                          .toString(),
                                      currentLang: "ar",
                                      profileImage: _userImage != null
                                          ? _userImage
                                          : "https://i1.sndcdn.com/avatars-sruQLEBrNij9SCng-RstNhA-t500x500.jpg");
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotificationOptionRow(String title, bool isActive) {
    return MergeSemantics(
      child: ListTile(
        title: Text(title),
        trailing: CupertinoSwitch(
          value: isActive,
          onChanged: (bool value) {
            setState(() {
              isActive = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            isActive = !isActive;
          });
        },
      ),
    );
  }

  void _showTestDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            title: Center(child: Text(_strController.errorCountry)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: MediaQuery.of(context).size.height* 0.7,
              width: MediaQuery.of(context).size.width* 1,
              child: ListView.builder(
                itemCount: _countryData.length,
                itemBuilder: (ctx, index) {
                  final list = _countryData[index];
                  // return Text(list.name);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCountry = list['name'];
                          _myCountry = list['id'];
                          print(_myCountry);
                          _dismissDialog(ctx: ctx);
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
                        //saveIssue();
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

  _dismissDialog({BuildContext ctx}) {
    Navigator.pop(ctx);
  }
}

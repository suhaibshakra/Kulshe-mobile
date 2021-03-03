import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';
import '../utilities/app_helpers/app_controller.dart';
import '../utilities/app_helpers/app_style.dart';
import '../utilities/app_helpers/my_widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _country = "";
  String _nickName = "";
  String _mobile = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String mobileCountryPhoneCode = "";
  String mobileCountryIsoCode = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ListView(
            children: [
              buildHeader(),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  //country
                  buildLabel(txt: "Country"),
                  buildTextField(
                      textInputType: TextInputType.text,
                      hintTxt: "Country",
                      onChanged:(val){
                        setState(() {
                          _country = val;
                        });
                      }),

                  //user name
                  buildLabel(txt: "Nick Name"),
                  buildTextField(
                      textInputType: TextInputType.name,
                      hintTxt: "Nick Name",
                      onChanged:(val){
                        setState(() {
                          _nickName = val;
                        });
                      }),

                  buildLabel(txt: "Mobile Number"),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(4)),
                            child: CountryListPick(
                              appBar: AppBar(
                                backgroundColor: Colors.red,
                                title: Text("Country"),
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
                                  mobileCountryIsoCode = code.code;
                                  mobileCountryPhoneCode =
                                      code.dialCode.replaceAll('+', '').toString();
                                  print('code : $mobileCountryPhoneCode');
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            child: buildTextField(
                                textInputType: TextInputType.phone,
                                hintTxt: "78XXXXXXX",
                                onChanged:(val){
                                  setState(() {
                                    _mobile = val;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // buildMobile(),

                  //email
                  buildLabel(txt: "Email Address"),
                  buildTextField(
                      textInputType: TextInputType.emailAddress,
                      hintTxt: "name@domain.com",
                      onChanged:(val){
                        setState(() {
                          _email = val;
                        });
                      }),

                  //password
                  buildLabel(txt: "Password"),
                  buildTextFieldPsw(
                      textInputType: TextInputType.visiblePassword,
                      onChanged:(val){
                        setState(() {
                          _password = val;
                        });
                      }),

                  //confirm password
                  buildLabel(txt: "Confirm Password"),
                  buildTextFieldPsw(
                      textInputType: TextInputType.visiblePassword,
                      onChanged:(val){
                        setState(() {
                          _confirmPassword = val;
                        });
                      }),
                ],
              ),
              buildSignUpBtn(context),
              GestureDetector(
                onTap: ()=>Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Do you have account?"),
                      buildLabel(txt: "Login"),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    buildRowOr(),
                    Text(
                      "Create Account Using",
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSocialIcons("assets/images/apple.png"),
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
        ),
      ),
    );
  }

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

  Widget buildSignUpBtn(BuildContext ctx) {
    return buildMainButton(
        btnColor: Colors.red.shade400,
        radius: 6,
        txt: AppController.strings.createAccount,
        txtColor: Colors.white,
        onPressedBtn: () {
          createAccountFunction(
              context: ctx,
              email: _email.toString(),
              password: _password.toString(),
              confirmPassword: _confirmPassword.toString(),
              countryId: "110",
              mobileNumber: _mobile[0].toString() == "0"
                  ? _mobile.replaceFirst('0', '')
                  : _mobile.toString(),
              nickName: _nickName.toString(),
              mobileCountryIsoCode: mobileCountryIsoCode,
              mobileCountryPhoneCode: mobileCountryPhoneCode);
        });
  }

  // Widget buildTextFieldPsw(
  //     {TextInputType textInputType, TextEditingController controller}) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 15),
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: textInputType,
  //       obscureText: true,
  //       decoration: InputDecoration(
  //           hintStyle: TextStyle(fontSize: 14),
  //           hintText: '••••••••••••',
  //           suffixIcon: Icon(Icons.remove_red_eye),
  //           enabledBorder: const OutlineInputBorder(
  //             borderSide: const BorderSide(color: Colors.grey, width: 1.0),
  //           ),
  //           border: OutlineInputBorder(
  //             borderSide: const BorderSide(color: Colors.grey, width: 1.0),
  //           ),
  //           contentPadding: EdgeInsets.all(10)),
  //     ),
  //   );
  // }

  Container buildHeader() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/header.png"),fit: BoxFit.fitWidth),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        gradient: LinearGradient(colors: [
          Colors.red.shade400,
          Colors.red.shade200,
          Colors.red.shade200,
          Colors.red.shade300,
          Colors.red.shade400,
        ]),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Text(
            AppController.strings.createAccount,
            style: AppStyle.textStyleHeader,
            textAlign: TextAlign.center,
          ),
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:kulshe/ui/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'app_widgets.dart';

class LangScreen extends StatefulWidget {
  @override
  _LangScreenState createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  setLang(String lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lang", lang);
  }
  pushPage(BuildContext context){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myButton(
                height: 50,
                width: mq.size.width * 0.8,
                fontSize: 25,
                context: context,
                txtColor: AppColors.whiteColor,
                btnTxt: "عربي",
                radius: 10,
                btnColor: AppColors.orangeColor,
                onPressed: () {
                  setLang("ar");
                  pushPage(context);
                }),
            SizedBox(height: 25,),
            myButton(
                height: 50,
                width: mq.size.width * 0.8,
                fontSize: 25,
                context: context,
                txtColor: AppColors.whiteColor,
                btnTxt: "English",
                radius: 10,
                btnColor: AppColors.orangeColor,
                onPressed: () {
                  setLang("en");
                  pushPage(context);
                }),
          ],
        ),
      ),
    );
  }
}

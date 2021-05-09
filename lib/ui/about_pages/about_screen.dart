import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/services.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String comeFrom;

  const PrivacyPolicyScreen({Key key, this.comeFrom}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  var _data;
  bool _loading = true;
  @override
  void initState() {
    GetAboutData.getData(id:widget.comeFrom == 'privacy'? 1:widget.comeFrom == 't&c'? 2 : 3)
        .then((value) {
      setState(() {
        print(value );
        _data = value[0]['responseData'];
        _loading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(centerTitle: true,bgColor: AppColors.whiteColor),
      body: Directionality(
        textDirection: AppController.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: _loading?Center(child: buildLoading(color: AppColors.green),):Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: buildTxt(txt: _data['title']['ar'].toString(),txtColor: AppColors.blackColor2.withOpacity(0.8),fontWeight: FontWeight.w700,fontSize: 22 ),),
                SizedBox(height: 20,),
                Center(child: buildTxt(txt: _data['intro']['ar'].toString(),txtColor: AppColors.blackColor2,fontWeight: FontWeight.w400,fontSize: 18 ),),
                SizedBox(height: 20,),
                Center(child: buildTxt(txt: _data['description']['ar'].toString(),txtColor: AppColors.blackColor2,fontWeight: FontWeight.w400,fontSize: 16 ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

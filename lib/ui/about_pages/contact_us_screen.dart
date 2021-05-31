import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_string.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/ui/auth/login.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _mobileCountryPhoneCode = TextEditingController();
  TextEditingController _mobileCountryIsoCode = TextEditingController();
  TextEditingController _message = TextEditingController();
  final _strController = AppController.strings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool successful ;
  String message = '' ;

  @override
  void initState() {
    successful = false;
    _mobileCountryPhoneCode.text = '962';
    _mobileCountryIsoCode.text = 'JO';
    super.initState();
  }
  void _validateAndSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      contactWithUs(
        context: context,
        email: _email.text,
        name: _name.text,
        mobileCountryPhoneCode: _mobileCountryPhoneCode.text,
        mobileNumber: _mobileNumber.text,
        mobileCountryIsoCode: _mobileCountryIsoCode.text,
        message: _message.text,
      ).then((value){
        if(value[0]!= 412){
          setState(() {
            successful = true;
            message = value[1].toString();
          });
        }
      });
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
       body: SafeArea(
         child: Directionality(
           textDirection: AppController.textDirection,
           child: Stack(
             children: [
               buildBg(),
               SingleChildScrollView(
                 child: Container(
                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                   child: Form(
                     key: _formKey,
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Hero(
                           tag: 'logo',
                           child: buildLogo(height: mq.size.height * 0.2),
                         ),
                         SizedBox(
                           height: 20,
                         ),
                         Container(
                           alignment: Alignment.bottomCenter,
                           child: buildTxt(
                               txt: _strController.contactWithUs,
                               fontSize: 25,
                               fontWeight: FontWeight.w700,
                               txtColor: AppColors.redColor),
                         ),

                         successful?
                         Container(
                           child: Center(
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 100),
                               child: Container(
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     boxShadow: [
                                       BoxShadow(
                                           color: AppColors.greenColor,
                                           offset: Offset(2, 2),
                                           blurRadius: 1,
                                           spreadRadius: 2)
                                     ]),
                                 child: GestureDetector(
                                   onTap: (){
                                     Navigator.pop(context);
                                   },
                                   child: Directionality(
                                     textDirection: TextDirection.ltr  ,
                                     child: Padding(
                                       padding: const EdgeInsets.all(16.0),
                                       child: Row(
                                         children: [
                                           Expanded(flex: 1,child: Icon(Icons.arrow_back_ios,color: AppColors.whiteColor,)),
                                           Expanded(flex: 5,
                                             child: buildTxt(txt: "$message",maxLine: 4,txtColor: AppColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 18,textAlign: TextAlign.center),
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ):Column(
                           children: [
                             SizedBox(
                               height: 20,
                             ),

                             Column(
                               children: [
                                 buildTextField(
                                     label: _strController.fullName,
                                     controller: _name,
                                     textInputType: TextInputType.name,
                                     validator: validateName),
                                 buildTextField(
                                   controller: _email,
                                   label: _strController.email,
                                   textInputType: TextInputType.emailAddress,
                                   validator: (value) =>
                                   EmailValidator.validate(value)
                                       ? null
                                       : _strController.errorEmail,
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
                                               flex: 5,
                                               child: Container(
                                                 height: 46,
                                                 padding: EdgeInsets.symmetric(
                                                     horizontal: 16),
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
                                                       style: appStyle(
                                                           fontSize: 18,
                                                           fontWeight:
                                                           FontWeight.w400),
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
                                                     // print(code.name);
                                                     // print(code.code);
                                                     // print(code.dialCode);
                                                     // print(code.dialCode);
                                                     // print(code.dialCode);
                                                     // print(code.flagUri);
                                                     setState(() {
                                                       _mobileCountryIsoCode.text =
                                                           code.code.toString();
                                                       _mobileCountryPhoneCode.text =
                                                           code.dialCode
                                                               .replaceAll('+', '')
                                                               .toString();
                                                       print('code : ${code.code}');
                                                       print(
                                                           'code iso : ${_mobileCountryIsoCode}');
                                                     });
                                                   },
                                                 ),
                                               ),
                                             ),
                                             Expanded(
                                               flex: 7,
                                               child: buildTextField(
                                                 fromPhone: true,
                                                 validator: validateMobile,
                                                 controller: _mobileNumber,
                                                 textInputType: TextInputType.phone,
                                                 label: _strController.mobile,
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                       SingleChildScrollView(
                                         child: Container(
                                           child: buildTextField(
                                             validator: (value) =>
                                             (_message.text == null ||
                                                 _message.text.isEmpty)
                                                 ? "يرجى إدخال النص"
                                                 : null,
                                             label: "نص الرسالة",
                                             controller: _message,
                                             minLines: 4,
                                             textInputType: TextInputType.multiline,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(
                               height: 20,
                             ),
                             Container(
                               child: myButton(
                                   context: context,
                                   height: mq.size.height * 0.06,
                                   width: double.infinity,
                                   btnTxt: _strController.send,
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

                       ],
                     ),
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Align(alignment: Alignment.topLeft,child: IconButton(icon: Icon(Icons.clear,color: AppColors.blackColor2,),onPressed: ()=>Navigator.pop(context),)),
               ),
             ],
           ),
         ),
       ),
    );
  }
}

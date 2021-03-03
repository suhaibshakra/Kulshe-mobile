import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kulshe/api/api.dart';
import 'package:toast/toast.dart';
import 'app_controller.dart';
import 'app_style.dart';

Widget buildBg(){
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(image: AssetImage("assets/images/main_bg.png"),fit: BoxFit.fill)
    ),
  );

}
Widget buildMainButton(
    {Color btnColor,
    Color txtColor,
    String txt,
    Function onPressedBtn,
    double radius}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      margin: EdgeInsets.only(top: 30.0),
      width: double.infinity,
      child: RaisedButton(
        color: btnColor,
        textColor: txtColor,
        elevation: 2.0,
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Text(
          txt,
          style: TextStyle(fontSize: 16.0),
        ),
        onPressed: onPressedBtn,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    ),
  ); //button: login
}

Widget buildTextField(
    {TextInputType textInputType, String hintTxt, Function onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        onChanged: onChanged,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintStyle: AppStyle.textStyleHint,
            hintText: hintTxt,
            // suffixIcon: Icon(Icons.email),
            enabledBorder: const OutlineInputBorder(
              borderSide: AppStyle.borderSideTxtField,
            ),
            border: OutlineInputBorder(
              borderSide: AppStyle.borderSideTxtField,
            ),
            contentPadding: EdgeInsets.all(10)),
      ),
    ),
  );
}

// Future viewToast(String alert, Color color) {
//   return Fluttertoast.showToast(
//     msg: alert,
//     toastLength: Toast.LENGTH_SHORT,
//     // gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 3,
//     // backgroundColor: Colors.red,
//     backgroundColor: color,
//     textColor: Colors.white,
//     fontSize: 18.0,
//   );
// }
void viewToast(BuildContext context, String alert, Color color, int gravity) {
  return Toast.show(
    alert,
    context,
    duration: Toast.LENGTH_LONG,
    gravity: gravity,
    backgroundColor: color,
    textColor: Colors.white,
    backgroundRadius: 4,
  );
}

Widget buildLabel({String txt,TextStyle style,Alignment alignment}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Align(
            alignment: alignment!=null ? alignment:Alignment.centerLeft,
            child: Text(
              txt,
              style:style!=null?style:AppStyle.textStyleLabel,
              textAlign: TextAlign.center,
            )),
      ),
    ),
  );
}

void buildDialog(
    {BuildContext context,
    String title,
    double height,
    TextInputType textInputType,
    String hintTxt,
    String labelTxt,
    String body,
    String controller,
    Function onChanged,
    bool withToast = false,
    Function action}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: height, //150
            child: Column(
              children: [
                Divider(
                  color: Colors.black,
                ),
                buildLabel(txt: labelTxt),
                buildTextField(
                    textInputType: textInputType,
                    hintTxt: hintTxt,
                    onChanged: onChanged),
                SizedBox(
                  height: 7,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              AppController.strings.cancel,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RaisedButton(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              AppController.strings.send,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: withToast == true
                                ? () {
                                    print('BODY:${controller.toString()}');
                                    forgetPasswordEmail(
                                        ctx, controller.toString());
                                  }
                                : action,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.6));
}

Widget buildTextFieldPsw(
    {TextInputType textInputType,
    TextEditingController controller,
    Function onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        onChanged: onChanged,
        keyboardType: textInputType,
        obscureText: true,
        decoration: InputDecoration(
            hintStyle: AppStyle.textStyleHint,
            hintText: '••••••••••••',
            suffixIcon: Icon(Icons.remove_red_eye),
            enabledBorder: const OutlineInputBorder(
              borderSide: AppStyle.borderSideTxtField,
            ),
            border: OutlineInputBorder(
              borderSide: AppStyle.borderSideTxtField,
            ),
            contentPadding: EdgeInsets.all(10)),
      ),
    ),
  );
}

Widget buildLoading(Color color) {
  return SpinKitCircle(
    color: color,
    // duration: Duration(seconds: 2),
    size: 80,
    // shape: BoxShape.rectangle,
    // type: SpinKitWaveType.center,
  );
}

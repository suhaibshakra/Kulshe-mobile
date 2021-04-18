import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/ui/ads_package/fliter_screen.dart';
import 'package:kulshe/ui/splash_screen.dart';

class SearchWidget extends StatelessWidget {
  //final performSearch;
  final onSubmit;

  const SearchWidget({Key key, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.search,
                color: Colors.black54,
              ),
              onTap: () {},
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: AppController.strings.search,hintStyle: appStyle(color: AppColors.blackColor2,fontSize: 16)),
                onSubmitted: onSubmit,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FilterScreen()));
              },
              child: Icon(
                FontAwesomeIcons.slidersH,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

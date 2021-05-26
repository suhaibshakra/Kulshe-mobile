import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/ui/ads_package/add_ad/add_ad_sections.dart';
import 'package:kulshe/ui/ads_package/public_ads_screen.dart';

class SearchWidget extends StatefulWidget {
  //final performSearch;
  // final onSubmit;

  const SearchWidget({Key key,}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  IconData icon = Icons.search;
  TextEditingController controller = TextEditingController();
  var text = "";

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
                icon,
                color: Colors.black54,
              ),
              onTap: () {
                setState(() {
                  controller.clear();
                });
                if(icon == Icons.close)
                  setState(() {
                    icon = Icons.search;
                  });
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: AppController.strings.search,hintStyle: appStyle(color: AppColors.blackColor2,fontSize: 16)),
                onSubmitted: (String val) {
                  if (val.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublicAdsScreen(
                            isPrivate: false,
                            fromHome: false,
                            isFav: false,
                            isFilter: false,
                            txt: val,
                          ),
                        ));
                    setState(() {
                      controller.clear();
                      icon = Icons.search;
                    });
                  }
                  print('DONE ...');
                  print('val:$val');
                },
                onChanged: (String val){
                  setState(() {
                    if(val.isEmpty){
                    icon = Icons.search;}else{
                      icon = Icons.close;
                    }
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAdSectionsScreen()));
              },
              child: CircleAvatar(
                backgroundColor: AppColors.grey.withOpacity(0.5),
                child: Icon(
                  FontAwesomeIcons.slidersH,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

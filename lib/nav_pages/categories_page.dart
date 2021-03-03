import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/model/sections.dart';
import '../services/services.dart';
import '../utilities/app_helpers/my_widgets.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _loading = true;

  List<Sections> _section;
  List<Datum> _sectionData;
  String _mySection;

  List<SubSection> _subSections;
  String _mySubSections;

  List<Attribute> _attribute;
  String _myAttribute;

  List<Option> _option;
  String _myOption;

  List<Brand> _brand;
  String _myBrand;

  List<SubBrand> _subBrand;
  String _mySubBrand;

  String token;

  String refreshToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SectionServices.getSections().then((value) {
      setState(() {
        _section = value;
        _sectionData = _section[0].data;
        _loading = false;
        print('_: ${_sectionData[0].name}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _loading
          ? buildLoading(Colors.redAccent)
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                    itemCount: _sectionData.length,
                    itemBuilder: (ctx, snapShot) {
                      var myData = _sectionData[snapShot];
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                          child: ExpansionTile(
                                backgroundColor: Colors.white,
                                title: Text(myData.name),
                                onExpansionChanged: (isExpand){
                                  print('Done $isExpand');

                            },
                                leading: Container(
                                    width: 30,
                                    height: 30,
                                    child: SvgPicture.string(
                                        ''' <svg style="width:24px;height:24px" viewBox="0 0 24 24">
    <path fill="#000" d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z" />
</svg> ''')),
                                children: [
                                  Divider(color: Colors.grey),
                                  Card(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("DATA",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          Container(height: 30,width: 2,color: Colors.white
                                            ,),
                                          Text("DATA",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    )
                                  ),
                                 ],
                              ),
                        ),

                      );
                    }),
              ),
            ),
    );
  }
}
/*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ExpansionTile(
                backgroundColor: Colors.greenAccent.withOpacity(0.2),
                title: Text("Account"),
                leading: Icon(Icons.person_outline),
                children: [
                  Divider(color: Colors.grey),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      leading: Icon(Icons.add),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text("Sign up"),
                      subtitle: Text("Where you can register in account"),
                      onTap: (){},
                    ),
                  ),
                  Card(
                    color: Colors.grey,
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text("Sign in"),
                      subtitle: Text("Where you can login in account"),
                      onTap: (){},
                    ),
                  )
                ],
              ),
            ),

          ],
        ),

 */

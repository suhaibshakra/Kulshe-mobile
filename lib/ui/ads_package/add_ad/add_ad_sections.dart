import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/ui/ads_package/filter_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_add_last.dart';
import 'add_ad_form.dart';

class AddAdSectionsScreen extends StatefulWidget {
  final comeFrom;

  AddAdSectionsScreen({Key key, this.comeFrom}) : super(key: key);

  @override
  _AddAdSectionsScreenState createState() => _AddAdSectionsScreenState();
}

class _AddAdSectionsScreenState extends State<AddAdSectionsScreen> {
  int _questionIndex = 0;
  List<Widget> _questionPages = [];
  // List<ResponseSectionDatum> _sectionData;
  List _sectionData;
  String _selectedCity;
  String _myCity;
  bool _loading = true;
  var _strController = AppController.strings;

  //add data id's
  int sectionID;
  int subSectionID;
  // List _localityData;
  @override
  void initState() {
    setState(() {
      _getSections();
    });
    super.initState();
  }
  // _getCountries() async {
  //   SharedPreferences _gp = await SharedPreferences.getInstance();
  //   final List<Countries> sections =
  //   countriesFromJson(_gp.getString("allCountriesData"));
  //   _countryData = sections[0].responseData;
  //   _localityData = _countryData[1].cities[1].localities;
  //   // print(sections[0].responseData[4].name);
  // }
  _getSections() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections =
        jsonDecode(_gp.getString("allSectionsData"));
    _sectionData = sections[0]['responseData'];
    _loading = false;
    callWidgets(_sectionData);
    // print(sections[0].responseData[4].name);
  }

  void callWidgets(List _mySec) {
    setState(() {
      _questionPages = [
        Center(
          child: ListView.builder(
            itemCount: _sectionData.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, index) {
              var _data = _sectionData[index];
              var _subSections = _sectionData[index]['sub_sections'] as List;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    backgroundColor: AppColors.whiteColor,
                    title: Text(_data['name']),
                    leading: Container(
                      width: 28,
                      height: 28,
                      child: Icon(Icons.camera),
                    ),
                    children: [
                      GridView.count(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: (3 / 1.4),
                        children: _subSections
                            .map(
                              (data) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sectionID = _data['id'];
                                    subSectionID = data['id'];
                                    _questionIndex -= 1;
                                  });
                                  print("Sub section id ${data['id']}");
                                  print("section id ${_data['id']}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddAdForm(
                                            section: _data['label']['ar'],
                                            sectionId: _data['id'],
                                            subSectionId: data['id'],
                                            fromEdit: false,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(data['name'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Column()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comeFrom == 'addAd'?"Add Ad":"Select Section"),
      ),
      body: _loading
          ? buildLoading(color: AppColors.green)
          : Center(
        child: ListView.builder(
          itemCount: _sectionData.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) {
            var _data = _sectionData[index];
            var _subSections = _sectionData[index]['sub_sections'] as List;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  backgroundColor: AppColors.whiteColor,
                  title: Text(_data['name']),
                  leading: Container(
                    width: 28,
                    height: 28,
                    child: Container(
                        width: 35,
                        height: 35,
                        child:
                        // _data[index]['icon']!=null?
                        SvgPicture.network(
                          // _data['icon']!=null?_data['icon']:
                          "https://svgsilh.com/svg/296742.svg",fit: BoxFit.fill,)
//                     :SvgPicture.string(
//                     ''' <svg style="width:24px;height:24px" viewBox="0 0 24 24">
//   <path fill="#000" d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z" />
// </svg> ''',color: AppColors.grey),
                    ),
                  ),
                  children: [
                    GridView.count(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: (3 / 1.4),
                      children: _subSections
                          .map(
                            (data) => GestureDetector(
                          onTap: () {
                            setState(() {
                              sectionID = _data['id'];
                              subSectionID = data['id'];
                              _questionIndex -= 1;
                            });
                            print("Sub section id ${data['id']}");
                            print("section id ${_data['id']}");
            widget.comeFrom == 'addAd'?Navigator.push(context,MaterialPageRoute(builder: (context) =>AddAdForm(section: _data['label']['ar'],sectionId: _data['id'],subSectionId: data['id'],fromEdit: false,),),):
            Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen(sectionId: _data['id'],subSectionId: data['id']),));
                             },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(data['name'].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _questionIndex += 1;
          });
        },
      ),
    );
  }
  // void _showCitiesDialog() {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       //context: _scaffoldKey.currentContext,
  //       builder: (context) {
  //         return AlertDialog(
  //           contentPadding: EdgeInsets.only(left: 15, right: 15),
  //           title: Center(child: Text(_strController.country)),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //           content: Container(
  //             height: AppSize.appHeight(context) * 0.7,
  //             width: AppSize.appWidth(context) * 1,
  //             child: ListView.builder(
  //               itemCount: _localityData.length,
  //               itemBuilder: (ctx, index) {
  //                 final list = _localityData[index];
  //                 // return Text(list.name);
  //                 return Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 5),
  //                   child: InkWell(
  //                     onTap: () {
  //                       setState(() {
  //                         _selectedCity = list.name;
  //                         _myCity = list.id.toString();
  //                         print(_myCity);
  //                         _dismissDialog(ctx: ctx);
  //                       });
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         SizedBox(
  //                           height: 25,
  //                         ),
  //                         Expanded(
  //                           flex: 4,
  //                           child: Text(
  //                             list.name,
  //                             maxLines: 3,
  //                           ),
  //                         ),
  //                        ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //           actions: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.16,
  //                   child: RaisedButton(
  //                     child: new Text(
  //                       'Fund',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     color: Color(0xFF121A21),
  //                     shape: new RoundedRectangleBorder(
  //                       borderRadius: new BorderRadius.circular(30.0),
  //                     ),
  //                     onPressed: () {
  //                       //saveIssue();
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: MediaQuery.of(context).size.width * 0.01,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(right: 70.0),
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width * 0.20,
  //                     child: RaisedButton(
  //                       child: new Text(
  //                         'Cancel',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       color: Color(0xFF121A21),
  //                       shape: new RoundedRectangleBorder(
  //                         borderRadius: new BorderRadius.circular(30.0),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.02,
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //       });
  // }

  _dismissDialog({BuildContext ctx}) {
    Navigator.pop(ctx);
  }
}

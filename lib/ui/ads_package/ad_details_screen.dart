import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:kulshe/services_api/api.dart';
import 'package:kulshe/services_api/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'play_video.dart';

class AdDetailsScreen extends StatefulWidget {
  final int adID;
  final String slug;

  AdDetailsScreen({@required this.adID, @required this.slug});

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final _strController = AppController.strings;
  final _drController = AppController.textDirection;
  TextEditingController _otherReason = new TextEditingController();
  int abuseID;
  String abuseReason;

  bool _showOtherReason = false;
  bool _loading = true;
  List _adDetails;
  int _selection = 0;

  @override
  void initState() {
    _selection = 1;
    AdDetailsServicesNew.getAdData(adId: widget.adID, slug: widget.slug)
        .then((value) {
      setState(() {
        _adDetails = value;
        // print('AD L : $_adDetails');
        // _adDetailsData = value[0]['responseData'];
        // _detailsAttribute = value[0]['responseData']['selected_attributes'];
        _loading = false;
      });
    });
    super.initState();
  }

  _launchURLWhatsApp(String mobile) async {
    var _url = 'https://api.whatsapp.com/send?phone=$mobile&text=...!';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  _launchURLEmail(String mail) async {}

  _launchCaller(String mobile) async {
    String str = "tel:" + mobile;
    if (await canLaunch(str)) {
      await launch(str);
    } else {
      throw 'Could not launch $str';
    }
  }

  List _myImages =[];
  Widget adsWidget(List images) {
    if(_myImages != [] )
    if(images != null){
     for(int i = 0;i<images.length;i++){
      _myImages.add(NetworkImage('${images[i]['medium']}'),);
    }}else{
      _myImages = [(AssetImage("assets/images/no_img.png"))];
    }
     Widget imageCarousel = new Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: _myImages,
        // [
        //   NetworkImage(
        //       'https://i.pinimg.com/originals/e6/14/2e/e6142eacd3e73a4075e959a611e94819.jpg'),
        //   NetworkImage(
        //       'https://www.fgdc.gov/img/slider/slider-bg-network.jpg/image'),
        //   NetworkImage(
        //       'https://www.fgdc.gov/img/slider/slider-bg-network.jpg/image'),
        //   NetworkImage(
        //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEXuRby1OzuqA3POVcC0wvtrgDgRCkpNqzbuTatWzOTSTUBDKLa2S2FjD5z_WfpH2jRHw&usqp=CAU')
        // ],
        autoplay: true,
        dotIncreasedColor: Colors.grey,
        dotBgColor: Colors.grey.withOpacity(0.2),
        overlayShadowColors: Colors.black,

        // animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000),
      ),
    );
    return
        // _load2 ? buildLoading(color: Colors.amber.shade700) :
        imageCarousel;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SafeArea(
      child: Directionality(
        textDirection: _drController,
        child: Scaffold(
          appBar: buildAppBar(bgColor: AppColors.whiteColor, centerTitle: true),
          // appBar: buildAppBar(
          //     centerTitle: true,
          //     bgColor: AppColors.whiteColor,
          //     themeColor: Colors.grey),
          // drawer: buildDrawer(context),
          backgroundColor: Colors.white,
          body: _loading
              ? buildLoading(color: AppColors.green)
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _adDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            var _details = _adDetails[0]['responseData'];
                            var _attributes = _adDetails[0]['responseData']
                                ['selected_attributes'];
                            var abuseReasons = _details['abuse_reasons'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_details['title'].toString(),
                                          style: appStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor2,
                                          fontWeight: FontWeight.w700,

                                          ),overflow: TextOverflow.visible,),
                                          buildIcons(
                                              iconData:
                                                  _details['is_favorite_ad'] ==
                                                          false
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                              color: Colors.red,
                                              size: 30,
                                              action: () {
                                                favoriteAd(
                                                  context: context,
                                                  adId: _details['id'],
                                                  state: _details[
                                                              'is_favorite_ad'] ==
                                                          true
                                                      ? "delete"
                                                      : "add",
                                                ).then((value) {
                                                  setState(() {
                                                    AdDetailsServicesNew
                                                            .getAdData(
                                                                adId:
                                                                    widget.adID,
                                                                slug:
                                                                    widget.slug)
                                                        .then((value) {
                                                      setState(() {
                                                        _adDetails = value;
                                                        // _adDetailsData = value[0]['responseData'];
                                                        // _detailsAttribute = value[0]['responseData']['selected_attributes'];
                                                        _loading = false;
                                                      });
                                                    });
                                                  });
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    if(!_details['is_free'])
                                      Container(
                                      width: double.infinity,
                                      child: _details['has_price'] && _details['price']!=0 &&  _details['currency']!=null
                                          ? Text(
                                              '${_details['price'].toString()}${_details['currency']['ar'].toString()}',
                                              style: appStyle(
                                                  color: Colors.green,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Text(_strController.callAdvPrice,
                                      style: appStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),),
                                    ),
                                    if(_details['is_free'])
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            _strController.free,
                                            style: appStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.greenColor),
                                            maxLines: 3,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                                adsWidget(_details['images']),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_details['show_contact'])
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            _details['user_contact']
                                                ['user_image']),
                                      ),
                                      Text(
                                        _details['user_contact']['nick_name'],
                                        style: appStyle(
                                            color: AppColors.blackColor2,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.whatsapp,
                                          color: AppColors.whiteColor,
                                          bgColor: AppColors.green,
                                          action: () {
                                            // _launchURLWhatsApp(_details['user_contact']['mobile_number'].toString());
                                          }),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.phoneAlt,
                                          bgColor: AppColors.blue,
                                          color: AppColors.whiteColor,
                                          action: () {
                                            // _launchCaller(_details['user_contact']['mobile_number'].toString());
                                            launch(
                                                "tel://${_details['user_contact']['mobile_number'].toString()}");
                                          }),
                                      buildIcons(
                                        iconData: FontAwesomeIcons.envelope,
                                        color: AppColors.whiteColor,
                                        bgColor: AppColors.redColor,
                                        action: () {
                                          _launchURLEmail(
                                            _details['user_contact']
                                                    ['mobile_number']
                                                .toString(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _attributes.length,
                                  itemBuilder:
                                      (BuildContext context, int position) {
                                    var _myAttributes = _attributes[position];
                                    var _selectedValue =
                                        _myAttributes['selected_value'];
                                    var _anotherData;

                                    // print('SELECTED: ${_myAttributes}');
                                    print('TYPE: ${_selectedValue.runtimeType}');
                                    var attributeName =
                                        (_selectedValue.runtimeType == int ||
                                                _selectedValue.runtimeType ==String ||
                                                _selectedValue.runtimeType ==double)
                                            ?_selectedValue.toString()
                                            : _selectedValue.runtimeType.toString() == "_InternalLinkedHashMap<String, dynamic>"? _selectedValue['name']['ar'].toString()
                                            : _selectedValue;
                                    var _myLabel = _attributes[position]['label'];

                                    // print('a type: ${attributeName.toString()}');
                                    return Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                _myLabel['ar'].toString(),
                                                style: appStyle(
                                                    fontSize: 18,
                                                    color: AppColors.blackColor,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          if(_selectedValue.runtimeType.toString() != "List<dynamic>" )
                                            Expanded(
                                            flex: 2,
                                            child: Text(
                                              attributeName.toString(),
                                              style: appStyle(
                                                fontSize: 16,
                                                color: AppColors.blackColor2,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                          if(_selectedValue.runtimeType.toString() == "List<dynamic>" )
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: 0),
                                              child: GridView.builder(shrinkWrap: true,physics: ClampingScrollPhysics()
                                                  ,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,childAspectRatio: 3), itemCount: attributeName.length,itemBuilder: (ctx,index){
                                                return Center(child: Text(attributeName[index]['name']['ar'].toString() + " , ",style: appStyle(fontWeight: FontWeight.w500),));
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      thickness: 1,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Text(
                                      _strController.callAdv,
                                      style: appStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: myButton(
                                        btnTxt: _strController.callUs,
                                        fontSize: 16,
                                        btnColor: Colors.lightBlueAccent,
                                        radius: 8,
                                        context: context,
                                        txtColor: AppColors.whiteColor,
                                        height: 45,
                                        onPressed: (){
                                          print('${_details['video']}');
                                            if(_details['video'] != null)
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideo(videoUrl: _details['video'],),),);
                                        }
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: myButton(
                                        btnTxt: "Send Email",
                                        fontSize: 16,
                                        btnColor: Colors.lightBlueAccent,
                                        radius: 8,
                                        context: context,
                                        txtColor: AppColors.whiteColor,
                                        height: 45,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      buildIcons(
                                          iconData: FontAwesomeIcons.facebookF,
                                          bgColor: Colors.blue,
                                          color: AppColors.whiteColor,
                                          action: () {}),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.instagram,
                                          color: AppColors.whiteColor,
                                          bgColor: Colors.deepOrangeAccent,
                                          action: () {}),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.twitter,
                                          bgColor: Colors.lightBlueAccent,
                                          color: AppColors.whiteColor,
                                          action: () {}),
                                      buildIcons(
                                          iconData: FontAwesomeIcons.linkedinIn,
                                          color: AppColors.whiteColor,
                                          bgColor: AppColors.blue,
                                          action: () {}),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(
                                        'REASON: ${abuseReasons.runtimeType}');
                                    _buildAbuseDialog(
                                        context: context,
                                        details: abuseReasons);
                                  },
                                  child: buildTxt(
                                      txt: "Report abuse",
                                      fontSize: 22,
                                      txtColor: AppColors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Text(
                                      _strController.adDetails,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Text(
                                      _details["body"].toString(),
                                      //  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                                      style: appStyle(
                                          color: AppColors.blackColor2,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                buildTextField(label: _strController.email),
                                SizedBox(
                                  height: 10,
                                ),
                                myButton(
                                    fontSize: 20,
                                    width: double.infinity,
                                    onPressed: () => print(''),
                                    height: 45,
                                    txtColor: AppColors.whiteColor,
                                    context: context,
                                    btnColor: AppColors.redColor,
                                    btnTxt: _strController.mobile,
                                    radius: 10),
                                SizedBox(
                                  height: 40,
                                ),
                                buildIconWithTxt(
                                  iconData:
                                      FontAwesomeIcons.exclamationTriangle,
                                  iconColor: Colors.amber,
                                  size: 25,
                                  label: Text(
                                    _strController.warning,
                                    style: appStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blackColor2),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    // "مع أكثر من 2 مليار مشاهدة شهرياً للإعلانات الموجودة عليها، تقوم بدورها بربط البائعين والمشترين بشكل فعلي؛ لتمكينهم من البيع والشراء أو الحصول على خدمة أو حتى وظيفة. يتكون فريق العمل في كل شي من أكثر من 160 موظف يتعاملون مع أكثر من 45 مليون فرد وشركة، ممّن يستخدمون منصتنا لبيع الكثير من السلع والمنتجات بقيمة تزيد عن 25 مليار دولار سنوياً، وذلك إلى جانب قيمة عروض الوظائف الشاغرة والخدمات التي يتم تداولها عبر المنصة. نحن في كل شي نعمل من أجل أن تصبح عمليات البيع والشراء أسهل وأسرع من الأسلوب المعتاد؛ حيث تم تصميم المنصة لتكون آمنة ومتاحة لجميع دون استثناء، سواء كان المستخدم يمثّل نفسه كـ فرد أو شركة. منذ تأسيس كل شي ، ساهم في خدمة جميع العملاء بمساعدتهم في إتمام عمليات البيع والشراء والإعلان أو البحث عن خدمة أو وظيفة شاغرة، وأصبح بعد ذلك الخيار الأول للمستخدمين العرب في منطقة الشرق الأوسط وشمال إفريقيا عبر الإنترنت؛ حيث أننا نقدم خدماتنا في 19 دولة، هي: الأردن، المملكة العربية السعودية، الإمارات العربية المتحدة، الكويت، العراق، سلطنة عُمان، مصر، البحرين، سوريا، لبنان، ليبيا، السودان، اليمن، قطر، فلسطين، الجزائر، المغرب، موريتانيا وتونس. نسعى في شركة كل شي جاهدين لتوفير بيئة إعلانية آمنة وموثوقة عبر الإنترنت، هدفها إيصال البائعين بالمشترين والعكس أيضاً، بشكل مباشر دون الحاجة إلى وجود وسيط أو دفع عمولة من خلال القوائم والتصنيفات الموجودة والتي يزيد عددها عن 120، مثل: المركبات، السيارات، العقارات، الإلكترونيات، ألعاب الفيديو، الهواتف المحمولة، الأثاث، الملابس والأزياء، الكتب والمجلات ومختلف أنواع الخدمات والقطاعات كذلك. رؤيتنا تتجلّى رؤيتنا في كل شي بتمكين الأفراد والشركات من تحقيق الربح من خلال خلق فرص اقتصادية جيدة بمردودها، وتحقيق الرغبات وتلبية الاحتياجات وتطوير المجتمعات. كيف نعمل؟ يمكن للمستخدمين تحميل تطبيقنا على الـ iOS والآندرويد للحصول على أفضل تجربة، أو استخدام موقعنا الإلكتروني للبيع والشراء والتقديم للحصول على وظيفة ما أو تقديم خدمة.",
                                  "لا ترسل أي معلومات شخصية أو صور أو أي أموال من خلال الإنترنت و قم بالازم للتأكد من صحة الإعلان و الجهة المعلنة. و توخى الحذر من الإعلانات التي تروج الربح السريع و تزوير الوثائق.",
                                style: appStyle(color: AppColors.blackColor2,fontWeight: FontWeight.w500,fontSize: 18),)
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _buildAbuseDialog(
      {BuildContext context,
      List<dynamic> details,
      Function action}) {
    return Alert(
      context: context,
      title: "Report Abuse",
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.45,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: details.length,
          itemBuilder: (ctx, index) {
            return
              // Row(
                // children: <Widget>[
                  Column(
                    children: [
                      RadioListTile(
                        value: details[index]['id'],
                        groupValue: _selection,
                        title: Text(
                          details[index]['reason'],style: TextStyle(color: Colors.black54),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _selection = val;
                            abuseID = val;
                            abuseReason = details[index]['reason'];
                            if(details[index]['id'] == 5){
                              setState(() {
                                _showOtherReason = true;
                              });
                            }else{
                              setState(() {
                                _showOtherReason = false;
                              });
                            }
                          });
                        },
                         selected: true,
                      ),
                      if(details[index]['id'] == 5 && _showOtherReason == true)
                        buildTextField(label: "reason",textInputType: TextInputType.text,controller: _otherReason,hintTxt: "Enter reason",fromPhone: false,)

                    ],
                  );
                  // Radio(
                  //   activeColor: Colors.red,
                  //   focusColor: Colors.white,
                  //   groupValue: _selection,
                  //   onChanged: (newVal) {
                  //     setSelectedRadio(newVal);
                  //   },
                  //   value: _selection,
                  // ),
                  // Text(
                  //   details[index]['reason'],
                  //   style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),
                  // ),
                // ],
              // );
          },
        ),
      ),
      buttons: [

        DialogButton(
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed:(){
            print(widget.adID);
            print(abuseID);
            print(abuseReason);
            abuseAd(context: context,adId: widget.adID,abuseId: abuseID,abuseDescription: _otherReason.text.isNotEmpty?_otherReason.text.toString():null);
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  setSelectedRadio(int val) {
    setState(() {
      _selection = val;
    });
  }

}

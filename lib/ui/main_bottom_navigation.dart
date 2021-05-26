import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_controller.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads_package/add_ad/add_ad_sections.dart';
import 'ads_package/latest_ads_screen.dart';
import 'ads_package/public_ads_list_screen.dart';
import 'ads_package/public_ads_screen.dart';
import 'ads_package/user_panel.dart';
import 'bottome_navigation_screens/categories.dart';

class MainBottomNavigation extends StatefulWidget {
  @override
  _MainBottomNavigationState createState() => new _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation>
    with TickerProviderStateMixin {
  List _sectionData;

  Widget _lastSelected;

  final _strController = AppController.strings;

  void _selectedTab(int index) {
    setState(
      () {
        _lastSelected = index == 0
            ? LatestAds()
            : index == 1
                ? CategoriesScreen()
                : index == 2
                    ? PublicAdsScreen(
                        isPrivate: false,
                        fromHome: true,
                        isFav: true,
                        isFilter: false,
                      )
                    : buildDrawer(context, () => print('Done'), fromNav: true);
      },
    );
  }

  @override
  void initState() {
    _getSections();
    super.initState();
  }

  _getSections() async {
    SharedPreferences _gp = await SharedPreferences.getInstance();
    final List sections = jsonDecode(_gp.getString("allSectionsData"));
    _sectionData = sections[0]['responseData'];
    setState(() {
      _lastSelected = LatestAds();
    });

    // print(sections[0].responseData[4].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _lastSelected,
      bottomNavigationBar: FABBottomAppBar(
        height: 52,
        color: Colors.grey.shade600,
        selectedColor: AppColors.redColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(
              iconData: Icons.home, text: AppController.strings.home),
          FABBottomAppBarItem(
              iconData: Icons.list, text: AppController.strings.categories),
          FABBottomAppBarItem(
              iconData: FontAwesomeIcons.solidHeart,
              text: AppController.strings.fav),
          FABBottomAppBarItem(
              iconData: Icons.more_horiz, text: AppController.strings.more),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.amberColor,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddAdSectionsScreen(
                  comeFrom: 'addAd',
                )));
      },
      tooltip: _strController.addAd,
      // child: Icon(Icons.add),
      child: Text(
        _strController.addAd,
        style: appStyle(
          fontWeight: FontWeight.w700,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});

  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }

  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FabWithIcons extends StatefulWidget {
  FabWithIcons({this.icons, this.onIconTapped});

  final List<IconData> icons;
  ValueChanged<int> onIconTapped;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}

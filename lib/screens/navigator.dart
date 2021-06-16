import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:map_app/generated/l10n.dart';
import 'package:map_app/screens/add_marker.dart';
import 'package:map_app/screens/home.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  var _currentIndex = 0;
  List tabs = [
    HomePage(),
    AddMarker(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            // _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.map_rounded),
              title: Text(S.of(context).navigatorMap),
              activeColor: Colors.orange,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.pin_drop_outlined),
              title: Text(S.of(context).navigatorAddMarker),
              activeColor: Colors.orange,
            ),
          ],
        ));
  }
}

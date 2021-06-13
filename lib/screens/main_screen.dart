import 'package:flutter/material.dart';

//My imports
import 'package:map_app/screens/favorites/favorites_screen.dart';
import 'package:map_app/screens/map/map_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    CirclePointsView(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Saved'),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Feather.home,
      //         color: kGoodLightGray,
      //       ),
      //       title: Text('HOME'),
      //       activeIcon: Icon(
      //         Feather.home,
      //         color: kGoodPurple,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         FontAwesome.calendar,
      //         color: kGoodLightGray,
      //       ),
      //       title: Text('CALENDAR'),
      //       activeIcon: Icon(
      //         FontAwesome.calendar,
      //         color: kGoodPurple,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         EvilIcons.user,
      //         color: kGoodLightGray,
      //         size: 36,
      //       ),
      //       title: Text('PROFILE'),
      //       activeIcon: Icon(
      //         EvilIcons.user,
      //         color: kGoodPurple,
      //         size: 36,
      //       ),
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

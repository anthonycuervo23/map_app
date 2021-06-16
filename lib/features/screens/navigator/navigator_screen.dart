import 'package:flutter/material.dart';
import 'package:map_app/features/screens/map/home.dart';
import 'package:map_app/features/screens/save_marker/save_marker.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key key}) : super(key: key);

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  PageController _pageController = PageController();

  List<Widget> _screen = [MapScreen(), SaveMarkerScreen()];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(onTap: _onItemTapped, items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: _selectedIndex == 0 ? Colors.red : Colors.grey,
            ),
            label: 'Map'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.control_point,
              color: _selectedIndex == 1 ? Colors.red : Colors.grey,
            ),
            label: 'Save marker'),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

//My imports
import 'package:map_app/core/repository/page_repository.dart';
import 'package:map_app/features/screens/map/home_map.dart';
import 'package:map_app/features/screens/save_marker/save_marker.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key key}) : super(key: key);

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  PageController pageController;

  List<Widget> _screen = [MapScreen(), SaveMarkerScreen()];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    pageController = context.read<PageRepository>().pageController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
          items: [
            BottomNavyBarItem(
                icon: Icon(
                  Icons.map,
                  color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                ),
                title: Text('Map')),
            BottomNavyBarItem(
                icon: Icon(
                  Icons.control_point,
                  color: _selectedIndex == 1 ? Colors.red : Colors.grey,
                ),
                title: Text('Save marker')),
          ]),
    );
  }
}

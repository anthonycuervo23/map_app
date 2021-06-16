import 'package:flutter/material.dart';
import 'package:map_app/core/repository/page_repository.dart';
import 'package:map_app/features/screens/map/home.dart';
import 'package:map_app/features/screens/save_marker/save_marker.dart';
import 'package:provider/provider.dart';

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
    pageController.jumpToPage(selectedIndex);
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

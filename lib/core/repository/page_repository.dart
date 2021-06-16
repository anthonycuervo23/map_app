import 'package:flutter/material.dart';

class PageRepository extends ChangeNotifier {

  PageController _pageController = PageController();

  PageController get pageController => _pageController;


}
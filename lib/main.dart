import 'package:flutter/material.dart';

//My imports
import 'package:map_app/core/main_theme.dart';
import 'package:map_app/core/routes.dart';
import 'package:map_app/screens/map/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.defaultTheme,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: MapScreen(),
    );
  }
}

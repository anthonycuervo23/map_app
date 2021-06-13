import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//My imports
import 'package:map_app/core/main_theme.dart';
import 'package:map_app/core/routes.dart';
import 'package:map_app/screens/map/loading_screen.dart';
import 'package:map_app/utils/custom_marker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: MultiProvider(
        providers: [
          Provider(create: (context) => CustomMarkerManager(), lazy: true)
        ],
        child: LoadingScreen(),
      ),
    );
  }
}

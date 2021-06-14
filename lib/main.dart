import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_app/providers/cubic/map/map_bloc.dart';
import 'package:map_app/providers/cubic/markers/marker_bloc.dart';
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
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.defaultTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.loading,
      ),
      providers: [
        Provider(create: (context) => CustomMarkerManager(), lazy: true),
        ChangeNotifierProvider(create: (_) => MapService()),
        ChangeNotifierProvider(
            create: (_) => MarkersService(FirebaseFirestore.instance)),
      ],
    );
    //
    //   MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: AppThemes.defaultTheme,
    //   onGenerateRoute: AppRoutes.onGenerateRoute,
    //   home: MultiProvider(
    //     providers: [
    //       Provider(create: (context) => CustomMarkerManager(), lazy: true),
    //       ChangeNotifierProvider(create: (_) => MapService()),
    //       ChangeNotifierProvider(
    //           create: (_) => MarkersService(FirebaseFirestore.instance)),
    //       //ChangeNotifierProvider(create: (_) => MapService()),
    //     ],
    //     child: LoadingScreen(),
    //   ),
    // );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/core/repository/page_repository.dart';
import 'package:map_app/features/screens/navigator/navigator_screen.dart';
import 'package:map_app/features/screens/splash/splash.dart';
import 'package:map_app/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) =>
            MarkerRepository(context, FirebaseFirestore.instance)),
    ChangeNotifierProvider(create: (_)=> PageRepository()),
    ChangeNotifierProvider(create: (context) => MapRepository(context)),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseApp,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme:
                  GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
              primarySwatch: Colors.orange,
            ),
            home: NavigatorScreen(),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        }
        return MaterialApp(home: Splash());
      },
    );
  }
}

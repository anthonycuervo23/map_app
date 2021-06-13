import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/bloc/location/location_bloc.dart';
import 'package:map_app/bloc/map/map_bloc.dart';

//My imports
import 'package:map_app/core/main_theme.dart';
import 'package:map_app/core/routes.dart';
import 'package:map_app/screens/map/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationBloc()),
        BlocProvider(create: (_) => MapBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.defaultTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: LoadingScreen(),
      ),
    );
  }
}

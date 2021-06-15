import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/providers/map/map_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

//My imports
import 'package:map_app/screens/main_screen.dart';
import 'package:map_app/core/routes.dart';
import 'package:map_app/helpers/main_helpers.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, fadeInMapNavigation(context, MainScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsAndLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data));
          } else {
            return Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
        },
      ),
    );
  }

  Future checkGpsAndLocation(BuildContext context) async {
    final gpsPermission = await Permission.location.isGranted;

    final isGpsActive = await Geolocator.isLocationServiceEnabled();

    if (gpsPermission && isGpsActive) {
      Navigator.pushReplacement(
          context, fadeInMapNavigation(context, MainScreen()));
      return '';
    } else if (!gpsPermission) {
      Navigator.pushReplacementNamed(context, AppRoutes.gpsAccess);
      return 'GPS permission is required';
    } else {
      return 'Need to activate GPS';
    }
  }
}

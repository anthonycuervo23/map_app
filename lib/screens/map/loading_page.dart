import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//My imports
import 'package:map_app/helpers/main_helpers.dart';
import 'package:map_app/screens/map/acess_gps_page.dart';
import 'package:map_app/screens/map/map_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

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
      final bool gpsActived = await Geolocator.isLocationServiceEnabled();
      if (gpsActived) {
        Navigator.pushReplacement(
            context, fadeInMapNavigation(context, MapScreen()));
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
              return Center(
                child: Text(snapshot.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
          }),
    );
  }

  Future checkGpsAndLocation(BuildContext context) async {
    //confirmamos si tenemos permiso gps
    final permisoGPS = await Permission.location.isGranted;
    //confirmamos que el gps este activado
    final bool gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (permisoGPS && gpsActivo) {
      Navigator.pushReplacement(
          context, fadeInMapNavigation(context, MapScreen()));
      return '';
    } else if (!permisoGPS) {
      Navigator.pushReplacement(
          context, fadeInMapNavigation(context, GpsAccessScreen()));
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Activa tu GPS';
    }
  }
}

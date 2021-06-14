import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

//My imports
import 'package:map_app/core/routes.dart';

class GpsAccessScreen extends StatefulWidget {
  @override
  _GpsAccessScreenState createState() => _GpsAccessScreenState();
}

class _GpsAccessScreenState extends State<GpsAccessScreen>
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
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, AppRoutes.loading);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('GPS is required to use this app!'),
          MaterialButton(
              child:
                  Text('Grant access', style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async {
                final status = await Permission.location.request();

                this._getGpsAccess(status);
              })
        ],
      )),
    );
  }

  void _getGpsAccess(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, AppRoutes.map);
        break;
      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsAccessScreen extends StatefulWidget {
  const GpsAccessScreen({Key key}) : super(key: key);

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
        Navigator.pushReplacementNamed(context, 'loading');
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
            Text('es necesario el GPS para usar esta app'),
            MaterialButton(
                child: Text(
                  'Solicitar Acceso',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                shape: StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                onPressed: () async {
                  final status = await Permission.location.request();
                  this.gpsAccess(status);
                }),
          ],
        ),
      ),
    );
  }

  void gpsAccess(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, 'map');
        break;
      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
    }
  }
}

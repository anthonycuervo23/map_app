import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:provider/provider.dart';

class BtnLocation extends StatefulWidget {
  const BtnLocation({Key key}) : super(key: key);

  @override
  _BtnLocationState createState() => _BtnLocationState();
}

class _BtnLocationState extends State<BtnLocation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.my_location,
              color: Colors.black87,
            ),
            onPressed: resetCamera),
      ),
    );
  }

  resetCamera() {
    final mapRepository = context.read<MapRepository>();
    mapRepository.mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(mapRepository.currentLocation.latitude,
                mapRepository.currentLocation.longitude),
            zoom: 10.0)))
        .then((val) {
      context.read<MarkerRepository>().setResetToggle(false);
    });
  }
}

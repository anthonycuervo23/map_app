import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:provider/provider.dart';

class BtnRemoveBearing extends StatefulWidget {
  const BtnRemoveBearing({Key key}) : super(key: key);

  @override
  _BtnRemoveBearingState createState() => _BtnRemoveBearingState();
}

class _BtnRemoveBearingState extends State<BtnRemoveBearing> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.rotate_left,
              color: Colors.black87,
            ),
            onPressed: removeBearing),
      ),
    );
  }

  removeBearing() {
    final markerRepository = context.read<MarkerRepository>();
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(markerRepository.currentMarker.position.latitude,
                markerRepository.currentMarker.position.longitude),
            bearing: markerRepository.currentBearing == 0.0
                ? markerRepository.currentBearing
                : markerRepository.currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      if (markerRepository.currentBearing == 0.0) {
      } else {
        markerRepository
            .setCurrentBearing(markerRepository.currentBearing - 90);
      }
    });
  }
}

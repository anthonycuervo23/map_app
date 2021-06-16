import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:provider/provider.dart';

class MarkerCard extends StatefulWidget {
  const MarkerCard({Key key}) : super(key: key);

  @override
  _MarkerCardState createState() => _MarkerCardState();
}

class _MarkerCardState extends State<MarkerCard> {
  @override
  Widget build(BuildContext context) {
    final markerRepository = context.watch<MarkerRepository>();
    List<Marker> clients = markerRepository.markers;
    return Container(
        height: 125.0,
        width: MediaQuery.of(context).size.width,
        child: markerRepository.markersToggle
            ? ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8.0),
                children: clients.map((element) {
                  return clientCard(element);
                }).toList(),
              )
            : Container(height: 1.0, width: 1.0));
  }

  Widget clientCard(client) {
    final markerRepository = context.watch<MarkerRepository>();
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: InkWell(
            onTap: () {
              markerRepository.setCurrentMarker(client);
              markerRepository.setCurrentBearing(90.0);
              zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 100.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Center(child: Text('marker name'))),
            )));
  }

  zoomInMarker(client) {
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(client.position.latitude, client.position.longitude),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      context.read<MarkerRepository>().setResetToggle(true);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  void initState() {
    super.initState();
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

  addBearing() {
    final markerRepository = context.read<MarkerRepository>();
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(markerRepository.currentMarker.position.latitude,
                markerRepository.currentMarker.position.longitude),
            bearing: markerRepository.currentBearing == 360.0
                ? markerRepository.currentBearing
                : markerRepository.currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      if (markerRepository.currentBearing == 360.0) {
      } else {
        markerRepository
            .setCurrentBearing(markerRepository.currentBearing + 90);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mapRepository = context.watch<MapRepository>();
    final markerRepository = context.watch<MarkerRepository>();
    List<Marker> clients = markerRepository.markers;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: RichText(
              text: TextSpan(
                  text: "CARROTS",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: " Map",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold))
              ])),
          centerTitle: true,
          leading: Container(),
          actions: [
            IconButton(
              onPressed: () {
                resetCamera();
              },
              icon: Icon(
                Icons.my_location_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: mapRepository.mapToggle
                        ? GoogleMap(
                            onMapCreated: (controller) {
                              mapRepository.setMapController(controller);
                            },
                            onLongPress: markerRepository.addMarker,
                            onCameraMove: (cameraPosition) =>
                                markerRepository.clearMarker(),
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    mapRepository.currentLocation.latitude,
                                    mapRepository.currentLocation.longitude),
                                zoom: 10.0),
                            markers: {
                              if (markerRepository.newMarker != null)
                                markerRepository.newMarker,
                              if (clients.isNotEmpty)
                                for (var i = 0; i < clients.length; i++)
                                  clients[i]
                            },
                          )
                        : Center(
                            child: Text(
                            'Loading.. Please wait..',
                            style: TextStyle(fontSize: 20.0),
                          ))),
                Positioned(
                    top: MediaQuery.of(context).size.height - 250.0,
                    left: 10.0,
                    child: Container(
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
                            : Container(height: 1.0, width: 1.0))),
                markerRepository.resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height - 50.0),
                        right: 60.0,
                        child: FloatingActionButton(
                            onPressed: addBearing,
                            mini: true,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.rotate_left)))
                    : Container(),
                markerRepository.resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height - 50.0),
                        right: 110.0,
                        child: FloatingActionButton(
                            onPressed: removeBearing,
                            mini: true,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.rotate_right)))
                    : Container()
              ],
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

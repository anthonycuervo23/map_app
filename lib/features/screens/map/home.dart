import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/features/widgets/widgets.dart';
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
        leading: SaveButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: BtnLocation(),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          mapRepository.mapToggle
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
                      target: LatLng(mapRepository.currentLocation.latitude,
                          mapRepository.currentLocation.longitude),
                      zoom: 10.0),
                  markers: {
                    if (markerRepository.newMarker != null)
                      markerRepository.newMarker,
                    if (clients.isNotEmpty)
                      for (var i = 0; i < clients.length; i++) clients[i]
                  },
                )
              : Center(
                  child: Text(
                  'Loading.. Please wait..',
                  style: TextStyle(fontSize: 20.0),
                )),
          Positioned(
            top: MediaQuery.of(context).size.height - 200.0,
            left: 10.0,
            child: MarkerCard(),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 140.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            markerRepository.resetToggle ? BtnAddBearing() : Container(),
            markerRepository.resetToggle ? BtnRemoveBearing() : Container()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/map_theme.dart';

class LocationService extends ChangeNotifier {
  Marker point;
  String name;
  double longitude;
  double latitude;

  Completer<GoogleMapController> _completerController = Completer();

  CoordinatesProvider(BuildContext context) {
    //init
    goCurrentPosition;
  }

  void addPoint(LatLng pos) {
    point = Marker(
        markerId: const MarkerId('point'),
        infoWindow:
            InfoWindow(title: 'lat: ${pos.latitude}, lon: ${pos.longitude}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose,
        ),
        position: pos);

    longitude = point.position.longitude;
    latitude = point.position.latitude;

    notifyListeners();
  }

  void clearPoint() {
    point = null;
    notifyListeners();
  }

  void setName(String text) {
    name = text;
    notifyListeners();
  }

  void setLongitude(String long) {
    longitude = double.parse(long);
    notifyListeners();
  }

  void setLatitude(String lat) {
    latitude = double.parse(lat);
    notifyListeners();
  }

  Future<void> get goCurrentPosition async {
    Position location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final GoogleMapController controller = await _completerController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 15),
    ));
  }

  void onMapCreated(GoogleMapController controller) {
    goCurrentPosition;
    _completerController.complete(controller);
    //  _location.onLocationChanged.listen((l) {});
  }

  Future<void> goTo(double latitude, double longitude) async {
    final CameraPosition _go = CameraPosition(
        bearing: 180, target: LatLng(latitude, longitude), tilt: 55, zoom: 15);

    final GoogleMapController controller = await _completerController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_go));
  }
}

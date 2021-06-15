import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/marker.dart';

class MapService extends ChangeNotifier {
  // MapService(BuildContext context) {
  //   getLocation();
  // }
  //
  // Completer<GoogleMapController> mapController = Completer();
  // int currentIndex = 0;
  // int index;
  // Position currentPosition;
  // bool locationExist = false;
  // Position location;
  //
  // set setCurrentIndex(int currentIndex) {
  //   this.currentIndex = currentIndex;
  //   notifyListeners();
  // }
  //
  // void setLocationExist(bool locationExist) {
  //   this.locationExist = locationExist;
  //   notifyListeners();
  // }
  //

  //
  // void getLocation() async {
  //   final GoogleMapController controller = await mapController.future;
  //   this.location = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   locationExist = true;
  //   this.currentPosition = this.location;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //         target: LatLng(currentPosition.latitude, currentPosition.longitude),
  //         zoom: 15),
  //   ));
  //   notifyListeners();
  // }
  //
  // void initMap(GoogleMapController controller) {
  //   getLocation();
  //   mapController.complete(controller);
  //   notifyListeners();
  // }
  //
  // //TODO: this make the camera go to marker
  // Future<void> goTo(double latitude, double longitude) async {
  //   final CameraPosition _go = CameraPosition(
  //       bearing: 180, target: LatLng(latitude, longitude), tilt: 55, zoom: 15);
  //
  //   final GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_go));
  // }
  Marker point;
  String name;
  double longitude;
  double latitude;
  int index;

  Completer<GoogleMapController> _completerController = Completer();

  MapService(BuildContext context) {
    //init
    goCurrentPosition;
  }

  void changeMarker(int index, Marker marker) async {
    final GoogleMapController controller = await _completerController.future;
    controller.animateCamera(CameraUpdate.newLatLng(marker.position));
    this.index = index;
    notifyListeners();
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

  void initMap(GoogleMapController controller) {
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

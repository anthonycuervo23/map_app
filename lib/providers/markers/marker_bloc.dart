import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/marker.dart';

class MarkersService extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  List<Marker> coordinates = [];
  Marker marker;
  int selectedItem;
  double lat;
  double lng;

  // void setCoordinates(List<MapMarker> coordinates) {
  //   this.coordinates = coordinates;
  //   notifyListeners();
  // }

  void setSelectedItem(int selectedItem) {
    this.selectedItem = selectedItem;
    notifyListeners();
  }

  MarkersService(this._firestore, BuildContext context) {
    assert(_firestore != null);
    _getMarkers;
  }

  void get _getMarkers {
    _firestore
        .collection('markers')
        .snapshots()
        .listen((data) => data.docs.forEach((doc) {
              coordinates.add(Marker(
                  markerId: MarkerId(doc.id.toString()),
                  infoWindow: InfoWindow(title: doc['name']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan,
                  ),
                  position: LatLng(doc['lat'], doc['lng'])));
            }));
    notifyListeners();
  }

  void addMarker(LatLng pos) {
    marker = Marker(
        markerId: const MarkerId('point'),
        infoWindow:
            InfoWindow(title: 'lat: ${pos.latitude}, lon: ${pos.longitude}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose,
        ),
        position: pos);

    lng = marker.position.longitude;
    lat = marker.position.latitude;

    notifyListeners();
  }

  void clearScreen() {
    marker = null;
    notifyListeners();
  }

  // void startFollowing() async{
  //   final GoogleMapController controller = await _completerController.future;
  //   this._positionSubscription = Geolocator.getPositionStream(
  //     desiredAccuracy: LocationAccuracy.high,
  //     distanceFilter: 10,
  //   ).listen((Position position) {
  //     final location = LatLng(position.latitude, position.longitude);
  //   });
  // }
  //
  // void stopFollowing() {
  //   this._positionSubscription?.cancel();
  // }

  // Stream<List<MapMarker>> getMarkers() {
  //   return _firestore.collection('markers').snapshots().map((snapshot) {
  //     return snapshot.docs
  //         .map((document) => MapMarker.fromJson(document.data()))
  //         .toList();
  //   });
  // }

  Future<void> addMarkerToFirestore(Map<String, dynamic> data) async {
    await _firestore.collection('markers').add(data);
  }
}

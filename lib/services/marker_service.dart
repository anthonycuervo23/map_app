import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/services/marker_repository.dart';

class MarkerService extends MarkerRepository {
  MarkerService(
      FirebaseFirestore db, GlobalKey<ScaffoldMessengerState> scaffoldKey)
      : super(db, scaffoldKey);

  @override
  Future<MapMarker> postMarker() async {
    //TODO: create markers from app
    // await db.collection('markers')
    //     .add({
    //       'name': name,
    //       'latitude': latitude,
    //       'longitude': longitude,
    //     })
    //     .then((value) => debugPrint("Location Added"))
    //     .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  @override
  Future<List<MapMarker>> getMarker() async {
    List<MapMarker> markersList = [];
    await db.collection('markers').get().then((value) {
      value.docs.forEach(
          (element) => markersList.add(MapMarker.fromJson(element.data())));
    });
    return markersList;
  }
}

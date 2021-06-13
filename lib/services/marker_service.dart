import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/services/marker_repository.dart';

class MarkerService extends MarkerRepository {
  MarkerService(
      FirebaseFirestore db, GlobalKey<ScaffoldMessengerState> scaffoldKey)
      : super(db, scaffoldKey);

  //TODO: EDITAR
  @override
  Future<MapMarker> postMarker() async {
    return await rootBundle
        .loadString('assets/json/polyline.json')
        .then((onValue) {
      db
          .collection('pathPolylines')
          .doc()
          .set({'polylines': json.decode(onValue)});
    });
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

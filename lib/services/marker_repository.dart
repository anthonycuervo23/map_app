import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//My imports
import 'package:map_app/models/marker.dart';

abstract class MarkerRepository {
  final FirebaseFirestore db;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  MarkerRepository(this.db, this.scaffoldKey);

  Future<List<MapMarker>> getMarker();

  Future<MapMarker> postMarker();
}

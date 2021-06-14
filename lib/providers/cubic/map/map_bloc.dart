import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/utils/custom_marker.dart';

part 'map_state.dart';

Completer<GoogleMapController> _completerController = Completer();

class MapService extends ChangeNotifier {
  GoogleMapController mapController;
  int currentIndex = 0;
  int index;

  set setCurrentIndex(int currentIndex) {
    this.currentIndex = currentIndex;
    notifyListeners();
  }

  void initMapController(GoogleMapController controller) {
    _completerController.complete(controller);

    notifyListeners();
  }

  void changeMarker(int index, MapMarker marker) async {
    final GoogleMapController controller = await _completerController.future;
    controller.animateCamera(CameraUpdate.newLatLng(marker.coordinates));
    this.index = index;
    notifyListeners();
  }
}

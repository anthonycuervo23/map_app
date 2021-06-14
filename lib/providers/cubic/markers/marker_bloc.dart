import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/services/marker_repository.dart';

part 'marker_state.dart';

// class PointsCubit extends Cubit<PointsState> {
//   PointsCubit(this.mapService) : super(PointsInitial());
//
//   final MarkerRepository mapService;
// //TODO: fetch markers directly from this file
//   Future<void> fetchPoints() async {
//     final responseItems = await mapService.getMarker();
//     if (responseItems != null)
//       emit(PointsCompleted(responseItems, selectedItem: 0));
//     else
//       emit(PointsError("Data Not Found"));
//   }
// }

class MarkersService extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  List<MapMarker> coordinates = [];
  int selectedItem;

  void setCoordinates(List<MapMarker> coordinates) {
    this.coordinates = coordinates;
    notifyListeners();
  }

  void setSelectedItem(int selectedItem) {
    this.selectedItem = selectedItem;
    notifyListeners();
  }

  MarkersService(this._firestore) : assert(_firestore != null);

  Future<List<MapMarker>> getMarkers() async {
    await _firestore.collection('markers').get().then((value) {
      value.docs.forEach(
          (element) => coordinates.add(MapMarker.fromJson(element.data())));
    });
    notifyListeners();
    return coordinates;
  }

  // Stream<List<MapMarker>> getMarkers() {
  //   return _firestore.collection('markers').snapshots().map((snapshot) {
  //     return snapshot.docs
  //         .map(
  //           (document) => MapMarker.fromJson(document.data()),
  //         )
  //         .toList();
  //   });
  // }

  Future<void> addMarkerToFirestore(Map<String, dynamic> data) async {
    await _firestore.collection('markers').add(data);
  }

  //TODO: use this to add new markers
  void addmarker(LatLng pos) {
    Marker(
        markerId: MarkerId('point'),
        infoWindow:
            InfoWindow(title: 'lat: ${pos.latitude}, lon: ${pos.longitude}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose,
        ),
        position: pos);
  }
}

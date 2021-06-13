import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/utils/custom_marker.dart';

part 'map_state.dart';

class LineCubit extends Cubit<LineState> {
  LineCubit() : super(GoogleMapsStateInitial(null, 0));

  List<Marker> markers = [];
  final int _markersWidth = 50;

  void initMapController(GoogleMapController controller) {
    emit(GoogleMapsStateInitial(controller, 0));
  }

  Future<void> initMapControllerMarkers(GoogleMapController controller,
      BuildContext context, List<MapMarker> coordinates) async {
    CustomMarkerManager markerManager = context.read<CustomMarkerManager>();

    for (var i = 0; i < coordinates.length; i++) {
      final icon = await markerManager.getCustomMarker(
          value: i,
          clusterColor: Colors.orange,
          textColor: Colors.white,
          width: _markersWidth);

      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: coordinates[i].coordinate,
          icon: icon));
    }

    emit(GoogleMapsStateMarkers(controller, 0, markers));
  }

  void updateMarkerWithNumber(int index, MapMarker coordinate) {
    state.controller
        .animateCamera(CameraUpdate.newLatLng(coordinate.coordinate));
    emit(MapsMarkerChange(state.controller, index));
  }

  void changeMarker(int index, MapMarker coordinate) {
    state.controller
        .animateCamera(CameraUpdate.newLatLng(coordinate.coordinate));
    emit(MapsMarkerChange(state.controller, index));
  }
}

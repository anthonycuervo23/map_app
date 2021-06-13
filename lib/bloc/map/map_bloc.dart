import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

//My imports
part 'map_state.dart';
part 'map_event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  GoogleMapController _mapController;

  //check if we already have a loaded map
  void initMap(GoogleMapController controller) {
    if (!state.mapLoaded) {
      this._mapController = controller;

      //TODO: change the map style
      add(OnMapLoaded());
    }
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapLoaded) {
      yield state.copyWith(mapLoaded: true);
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/map_theme.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  GoogleMapController _mapController;

  //Polylines
  Polyline _route = Polyline(
      polylineId: PolylineId('my_route'), width: 4, color: Colors.transparent);

  Polyline _destinationRoute = Polyline(
      polylineId: PolylineId('my_destination_route'),
      width: 4,
      color: Colors.black87);

  void initMap(GoogleMapController controller) {
    if (!state.mapLoaded) {
      this._mapController = controller;

      //aqui podemos cambiar el estilo del mapa
      this._mapController.setMapStyle(jsonEncode(retroMapTheme));

      add(OnMapLoaded());
    }
  }

  void moveCamera(LatLng myLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(myLocation);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapLoaded) {
      yield state.copyWith(mapLoaded: true);
    } else if (event is OnLocationUpdate) {
      yield* _onLocationUpdate(event);
    } else if (event is OnShowRoute) {
      yield* _onShowRoute(event);
    } else if (event is OnFollowRoute) {
      yield* _onFollowRoute(event);
    } else if (event is OnMapMove) {
      yield state.copyWith(centralLocation: event.centerMap);
    } else if (event is OnCreateRoute) {
      yield* _onCreateRoute(event);
    }
  }

  Stream<MapState> _onLocationUpdate(OnLocationUpdate event) async* {
    if (state.followRoute) {
      this.moveCamera(event.location);
    }

    final List<LatLng> points = [...this._route.points, event.location];
    this._route = this._route.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._route;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapState> _onShowRoute(OnShowRoute event) async* {
    if (!state.drawRoute) {
      this._route = this._route.copyWith(colorParam: Colors.deepOrange);
    } else {
      this._route = this._route.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._route;

    yield state.copyWith(
        drawRoute: !state.drawRoute, polylines: currentPolylines);
  }

  Stream<MapState> _onFollowRoute(OnFollowRoute event) async* {
    if (!state.followRoute) {
      this.moveCamera(this._route.points[this._route.points.length - 1]);
    }
    yield state.copyWith(followRoute: !state.followRoute);
  }

  Stream<MapState> _onCreateRoute(OnCreateRoute event) async* {
    print(event.routeCoordinates);
    this._destinationRoute =
        this._destinationRoute.copyWith(pointsParam: event.routeCoordinates);

    final currentPolylines = state.polylines;
    currentPolylines['my_destination_route'] = this._destinationRoute;

    //Markers
    final starterMarker = Marker(
        markerId: MarkerId('start'),
        position: event.routeCoordinates[0],
        infoWindow:
            InfoWindow(title: 'My house', snippet: 'this is where I leave'));

    final endMarker = Marker(
      markerId: MarkerId('end'),
      position: event.routeCoordinates[event.routeCoordinates.length - 1],
    );

    final newMarkers = {...state.markers};
    newMarkers['start'] = starterMarker;
    newMarkers['end'] = endMarker;

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}

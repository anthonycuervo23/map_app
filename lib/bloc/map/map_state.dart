part of 'map_bloc.dart';

@immutable
class MapState {
  final bool mapLoaded;
  final bool drawRoute;
  final bool followRoute;
  final LatLng centralLocation;

  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState(
      {this.mapLoaded = false,
      this.drawRoute = false,
      this.followRoute = false,
      this.centralLocation,
      Map<String, Polyline> polylines,
      Map<String, Marker> markers})
      : this.polylines = polylines ?? Map(),
        this.markers = markers ?? Map();

  MapState copyWith(
      {bool mapLoaded,
      LatLng centralLocation,
      bool drawRoute,
      bool followRoute,
      Map<String, Polyline> polylines,
      Map<String, Marker> markers}) {
    return MapState(
        mapLoaded: mapLoaded ?? this.mapLoaded,
        drawRoute: drawRoute ?? this.drawRoute,
        markers: markers ?? this.markers,
        centralLocation: centralLocation ?? this.centralLocation,
        followRoute: followRoute ?? this.followRoute,
        polylines: polylines ?? this.polylines);
  }
}

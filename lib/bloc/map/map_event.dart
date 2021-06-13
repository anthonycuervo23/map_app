part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapLoaded extends MapEvent {}

class OnShowRoute extends MapEvent {}

class OnFollowRoute extends MapEvent {}

class OnCreateRoute extends MapEvent {
  final List<LatLng> routeCoordinates;
  final double distance;
  final double duration;

  OnCreateRoute(this.routeCoordinates, this.distance, this.duration);
}

class OnMapMove extends MapEvent {
  final LatLng centerMap;

  OnMapMove(this.centerMap);
}

class OnLocationUpdate extends MapEvent {
  final LatLng location;

  OnLocationUpdate(this.location);
}

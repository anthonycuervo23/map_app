part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class OnChangedLocation extends LocationEvent {
  final LatLng location;
  OnChangedLocation(this.location);
}

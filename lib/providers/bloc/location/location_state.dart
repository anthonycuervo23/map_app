part of 'location_bloc.dart';

@immutable
class LocationState {
  final bool isFollowing;
  final bool locationExist;
  final LatLng location;

  LocationState(
      {this.isFollowing = false, this.location, this.locationExist = false});

  LocationState copyWith(
      {bool isFollowing, bool locationExist, LatLng location}) {
    return LocationState(
        isFollowing: isFollowing ?? this.isFollowing,
        locationExist: locationExist ?? this.locationExist,
        location: location ?? this.location);
  }
}

part of 'location_bloc.dart';

@immutable
class LocationState {
  final bool follow;
  final bool locationExist;
  final LatLng location;

  LocationState(
      {this.follow = true, this.locationExist = false, this.location});

  LocationState copyWith({bool follow, bool locationExist, LatLng location}) {
    return LocationState(
        follow: follow ?? this.follow,
        locationExist: locationExist ?? this.locationExist,
        location: location ?? this.location);
  }
}

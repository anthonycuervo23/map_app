import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

//My imports
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState());

  StreamSubscription<Position> _positionSubscription;

  void startFollowing() {
    this._positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      add(OnChangedLocation(newLocation));
    });
  }

  void stopFollowing() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is OnChangedLocation) {
      yield state.copyWith(locationExist: true, location: event.location);
    }
  }
}

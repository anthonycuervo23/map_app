part of 'map_bloc.dart';

@immutable
class MapState {
  final bool mapLoaded;

  MapState({this.mapLoaded = false});

  copyWith({bool mapLoaded}) {
    return MapState(mapLoaded: mapLoaded ?? this.mapLoaded);
  }
}

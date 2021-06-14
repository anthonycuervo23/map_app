import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker {
  double lat;
  double long;
  String name;

  LatLng get coordinates => LatLng(long, lat);

  MapMarker({this.lat, this.long, this.name});

  factory MapMarker.fromJson(Map<String, dynamic> jsonData) {
    return MapMarker(
        lat: jsonData['lat'], long: jsonData['lng'], name: jsonData['name']);
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MapMarker && o.lat == lat && o.long == long && o.name == name;
  }

  @override
  int get hashCode => lat.hashCode ^ long.hashCode ^ name.hashCode;

  @override
  MapMarker fromJson(Map<String, Object> json) => MapMarker.fromJson(json);
}

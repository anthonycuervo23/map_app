import 'package:map_app/core/model/weather_model.dart';

class MarkerModel {
  String id;
  String name;
  double latitude;
  double longitude;
  Forecast weather;

  MarkerModel(
      {this.name, this.id, this.latitude, this.longitude, this.weather});

  // factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
  //     name: json['name'],
  //     id: json['id'],
  //     latitude: json['latitude'],
  //     longitude: json['longitude'],
  //     weather: json["weather"]);
}

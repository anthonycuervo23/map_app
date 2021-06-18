import 'package:map_app/core/model/weather_model.dart';

class MarkerModel {
  int id;
  String name;
  String description;
  double latitude;
  double longitude;
  Forecast weather;

  MarkerModel(
      {this.id,
      this.name,
      this.description,
      this.latitude,
      this.longitude,
      this.weather});

  factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      weather: json["weather"]);
}

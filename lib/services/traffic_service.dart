import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/route_response.dart';
import 'package:map_app/models/search_response.dart';

class TrafficService {
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }
  //para hacer peticiones http
  //TODO: cambiar mejor por http
  final _dio = Dio();
  final String _baseUrlDirection = 'https://api.mapbox.com/directions/v5';
  final String _baseUrlGeolocation = 'https://api.mapbox.com/geocoding/v5';

  final _apiKey =
      'pk.eyJ1IjoiamVhbmN1ZXJ2bzIzOTAiLCJhIjoiY2twdHcwenA3MG9jMTJwbzFhdndmdzdnbiJ9.LVhPRUaKoD895FMiqpX_mA';

  Future<RouteResponse> getStartAndEndCoordinates(
      LatLng start, LatLng end) async {
    print('start point: ${start}');
    print('end point: ${end}');
    final coordinateString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '${this._baseUrlDirection}/mapbox/driving/$coordinateString';
    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });
    final data = RouteResponse.fromJson(resp.data);

    return data;
  }

  Future<SearchResponse> getSearchResults(
      String search, LatLng proximity) async {
    final url = '${this._baseUrlGeolocation}/mapbox.places/$search.json';

    try {
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': 'true',
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'language': 'es',
      });
      final data = searchResponseFromJson(resp.data);

      return data;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }
}

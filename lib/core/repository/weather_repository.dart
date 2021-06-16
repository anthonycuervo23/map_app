import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:map_app/core/model/weather_model.dart';

class WeatherRepository {
  List<Weather> _weather = [];

  get weather => _weather;

  Future fetchWeather(String latitude, String longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=a7e029ae76daf0951c937dd71421c6b0'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

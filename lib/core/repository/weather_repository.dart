import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  List _weather = [];

  Future fetchWeather(String latitude, String longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=a7e029ae76daf0951c937dd71421c6b0'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      this._weather = jsonData['weather'];
      return this._weather;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

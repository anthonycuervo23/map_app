import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:map_app/core/model/weather_model.dart';

class NetworkHelper {
  NetworkHelper({this.url});

  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final Forecast forecast = Forecast.fromJson(data);
      return forecast;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

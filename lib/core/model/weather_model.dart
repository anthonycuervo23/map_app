class Weather {
  final String description;
  final int id;

  Weather({this.description, this.id});

  factory Weather.fromJson(Map<String, dynamic> parsedJson) {
    return Weather(
        description: parsedJson['description'], id: parsedJson['id']);
  }
}

class MainWeather {
  final double temp;

  const MainWeather({
    this.temp,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) {
    return MainWeather(temp: json['temp']);
  }
}

class Forecast {
  final List<Weather> weather;
  final MainWeather main;

  Forecast({this.weather, this.main});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'] != null && json['weather'].length != 0
        ? json['weather']
            .map<Weather>((data) => Weather.fromJson(data))
            .toList()
        : [];

    return Forecast(
      weather: weather,
      main: MainWeather.fromJson(json['main']),
    );
  }
}

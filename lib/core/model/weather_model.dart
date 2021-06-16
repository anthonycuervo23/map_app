class Weather {
  final String description;
  final String main;
  final String icon;

  Weather({this.description, this.main, this.icon});

  factory Weather.fromJson(Map<String, dynamic> parsedJson) {
    return Weather(
        description: parsedJson['description'],
        main: parsedJson['main'],
        icon: parsedJson['icon']);
  }
}

class Climate{
  final List<Weather> weather;
  final double temp;

  Climate({this.weather, this.temp});

  factory Climate.fromJson(Map<String, dynamic> parsedJson){
    return Climate(
      weather: parsedJson['weather'],
      temp: parsedJson['temp']
    );
  }

}

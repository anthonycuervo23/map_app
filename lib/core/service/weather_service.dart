//My imports
import 'package:map_app/core/model/weather_model.dart';
import 'package:map_app/core/service/weather_network.dart';

const apiKey = 'a7e029ae76daf0951c937dd71421c6b0';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Forecast weatherData;

  Future<Forecast> getLocationWeather(double latitude, double longitude) async {
    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$openWeatherMapURL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    this.weatherData = await networkHelper.getData();
    return this.weatherData;
  }

  String getWeatherSVGNetwork(int condition) {
    if (condition < 300) {
      return 'https://www.flaticon.com/svg/static/icons/svg/3026/3026385.svg';
    } else if (condition < 400) {
      return 'https://www.flaticon.com/svg/static/icons/svg/899/899693.svg';
    } else if (condition < 600) {
      return 'https://www.flaticon.com/svg/static/icons/svg/2921/2921803.svg';
    } else if (condition < 700) {
      return 'https://www.flaticon.com/svg/static/icons/svg/2834/2834554.svg';
    } else if (condition < 800) {
      return 'https://www.flaticon.com/svg/static/icons/svg/2446/2446001.svg';
    } else if (condition == 800) {
      return 'https://www.flaticon.com/svg/static/icons/svg/146/146199.svg';
    } else if (condition <= 804) {
      return 'https://www.flaticon.com/svg/static/icons/svg/899/899681.svg';
    } else {
      return 'https://www.flaticon.com/svg/static/icons/svg/2471/2471920.svg';
    }
  }
}

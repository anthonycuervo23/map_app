import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/core/service/weather_service.dart';

class MapRepository extends ChangeNotifier {
  Position _currentLocation;
  bool _mapToggle = false;
  GoogleMapController _mapController;

  MapRepository(BuildContext context) {
    _getCurrentLocation;
  }

  GoogleMapController get mapController => _mapController;

  void setMapController(GoogleMapController controller) {
    this._mapController = controller;
  }

  bool get mapToggle => _mapToggle;
  Position get currentLocation => _currentLocation;

  void get _getCurrentLocation {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      this._currentLocation = location;
      this._mapToggle = true;
      WeatherModel().getLocationWeather(
          this._currentLocation.latitude, this._currentLocation.longitude);
      notifyListeners();
    });
  }
}

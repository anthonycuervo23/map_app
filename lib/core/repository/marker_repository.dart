import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/model/marker_model.dart';
import 'package:map_app/core/model/weather_model.dart';
import 'package:map_app/core/service/weather_service.dart';

class MarkerRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  bool _markersToggle = false;
  bool _resetToggle = false;
  double _currentBearing;
  MarkerModel _currentMarker;
  double _longitude;
  double _latitude;
  Marker _newMarker;
  String _markerName;
  List<MarkerModel> customMarkers = [];
  List<Marker> markers = [];
  Forecast _weatherDataNewMarker;
  List<Map<String, dynamic>> _weatherDataAllMarkers;

  MarkerRepository(BuildContext context, this._firestore) {
    assert(_firestore != null);

    _populateClients;
  }

  bool get resetToggle => _resetToggle;
  double get currentBearing => _currentBearing;
  MarkerModel get currentMarker => _currentMarker;
  bool get markersToggle => _markersToggle;
  double get longitude => _longitude;
  double get latitude => _latitude;
  String get markerName => _markerName;
  Marker get newMarker => _newMarker;
  Forecast get weatherData => _weatherDataNewMarker;
  List<Map<String, dynamic>> get weatherDataAllMarkers =>
      _weatherDataAllMarkers;

  void setCurrentMarker(MarkerModel currentMarker) {
    this._currentMarker = currentMarker;
  }

  void setCurrentBearing(double currentBearing) {
    this._currentBearing = currentBearing;
  }

  void setResetToggle(bool resetToggle) {
    this._resetToggle = resetToggle;
    notifyListeners();
  }

  Future createMarker(Map<String, dynamic> data) async {
    await _firestore.collection('markers').add(data);
  }

  Future<void> get _populateClients {
    _firestore.collection('markers').snapshots().listen((data) {
      if (data.docs.isNotEmpty) {
        this._markersToggle = true;

        data.docs.forEach((doc) async {
          this._weatherDataNewMarker =
              await WeatherModel().getLocationWeather(doc['lat'], doc['long']);
          customMarkers.add(MarkerModel(
              name: doc['name'],
              description: doc['description'],
              latitude: doc['lat'],
              longitude: doc['long'],
              id: doc['id'],
              weather: this._weatherDataNewMarker));
          markers.add(Marker(
              markerId: MarkerId((doc['lat'] + doc['long']).toString()),
              position: LatLng(doc['lat'], doc['long']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueCyan,
              ),
              infoWindow: InfoWindow(title: doc['name'])));
        });
      }
    });

    notifyListeners();
  }

  Future<void> addMarker(LatLng pos) async {
    this._newMarker = Marker(
        markerId: MarkerId('point'),
        infoWindow:
            InfoWindow(title: 'lat: ${pos.latitude}, lon: ${pos.longitude}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        position: pos);
    print(pos);

    this._longitude = this._newMarker.position.longitude;
    this._latitude = this._newMarker.position.latitude;
//Weather for the marker I create on long press
//     this._weatherDataNewMarker = await WeatherModel()
//         .getLocationWeather(this._latitude, this._longitude);

    notifyListeners();
  }

  void clearMarker() {
    this._newMarker = null;
    notifyListeners();
  }
}

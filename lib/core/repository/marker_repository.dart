import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  bool _markersToggle = false;
  bool _resetToggle = false;
  double _currentBearing;
  Marker _currentMarker;
  double _longitude;
  double _latitude;
  Marker _newMarker;
  String _markerName;
  List<Marker> markers = [];

  MarkerRepository(BuildContext context, this._firestore) {
    assert(_firestore != null);

    _populateClients;
  }

  bool get resetToggle => _resetToggle;
  double get currentBearing => _currentBearing;
  Marker get currentMarker => _currentMarker;
  bool get markersToggle => _markersToggle;
  double get longitude => _longitude;
  double get latitude => _latitude;
  String get markerName => _markerName;
  Marker get newMarker => _newMarker;

  void setCurrentMarker(Marker currentMarker) {
    this._currentMarker = currentMarker;
  }

  void setCurrentBearing(double currentBearing) {
    this._currentBearing = currentBearing;
  }

  void setResetToggle(bool resetToggle) {
    this._resetToggle = resetToggle;
    notifyListeners();
  }

  void get _populateClients {
    markers.clear();
    _firestore.collection('markers').get().then((data) {
      if (data.docs.isNotEmpty) {
        this._markersToggle = true;

        for (int i = 0; i < data.docs.length; ++i) {
          markers.add(Marker(
              markerId: MarkerId(data.docs[i].id.toString()),
              infoWindow: InfoWindow(title: data.docs[i]['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueCyan,
              ),
              position: LatLng(data.docs[i]['lat'], data.docs[i]['long'])));
        }
      } else
        print(
            '========================================>${data.docs.length} error fetching data');
    });

    notifyListeners();
  }

  void addMarker(LatLng pos) {
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

    notifyListeners();
  }

  void clearMarker() {
    this._newMarker = null;
    notifyListeners();
  }
}

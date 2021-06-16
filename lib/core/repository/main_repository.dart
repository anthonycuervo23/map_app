import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainRepository extends ChangeNotifier {
  List<Marker> allMarkers;

  MainRepository({this.allMarkers});
}

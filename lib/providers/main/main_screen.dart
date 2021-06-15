import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MainScreenService extends ChangeNotifier {
  MainScreenService({this.markerStream});

  StreamSubscription markerStream;
}

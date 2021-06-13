import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyline/polyline.dart' as Poly;

//My imports
import 'package:map_app/bloc/location/location_bloc.dart';
import 'package:map_app/bloc/map/map_bloc.dart';
import 'package:map_app/bloc/search/search_bloc.dart';
import 'package:map_app/helpers/main_helpers.dart';
import 'package:map_app/models/search_result.dart';
import 'package:map_app/search/destination.dart';
import 'package:map_app/services/traffic_service.dart';

part 'btn_location.dart';
part 'btn_route.dart';
part 'btn_follow.dart';
part 'searchBar.dart';
part 'marker.dart';

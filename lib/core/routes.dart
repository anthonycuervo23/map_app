import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//My imports
import 'package:map_app/screens/favorites/favorites_screen.dart';
import 'package:map_app/screens/map/acess_gps_page.dart';
import 'package:map_app/screens/map/loading_page.dart';
import 'package:map_app/screens/map/map_page.dart';


class AppRoutes {
  static const map = "/";
  static const favorites = "favorites";
  static const gpsAccess = "access";
  static const loading = "loading";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case map:
              return MapScreen();
            case gpsAccess:
              return GpsAccessScreen();
            case loading:
              return LoadingScreen();
            case favorites:
              return FavoritesScreen();
            default:
              return LoadingScreen();
          }
        });
  }
}

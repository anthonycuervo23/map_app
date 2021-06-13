import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/bloc/location/location_bloc.dart';
import 'package:map_app/bloc/map/map_bloc.dart';

//My imports
import 'package:map_app/core/routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    context.read<LocationBloc>().startFollowing();
    super.initState();
  }

  @override
  void dispose() {
    context.read<LocationBloc>().stopFollowing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Carrots LAP Map app'),
        ),
        body: BlocBuilder<LocationBloc, LocationState>(
            builder: (BuildContext context, state) {
          return buildMap(state);
        }));
  }

  Widget buildMap(LocationState state) {
    if (!state.locationExist)
      return Center(child: Text('getting your location.....'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final cameraPosition = CameraPosition(target: state.location, zoom: 15);

    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapBloc.initMap(controller);
        },
      );
    });
  }
}

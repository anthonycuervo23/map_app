import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/bloc/location/location_bloc.dart';
import 'package:map_app/bloc/map/map_bloc.dart';
import 'package:map_app/widgets/widgets.dart';

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
      body: Stack(
        children: [
          BlocBuilder<LocationBloc, LocationState>(
            builder: (BuildContext context, state) {
              return buildMap(state);
            },
          ),
          Positioned(top: 10, child: SearchBar()),
          ManualMarker(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [BtnLocation(), BtnFollow(), BtnRoute()],
      ),
    );
  }

  Widget buildMap(LocationState state) {
    if (!state.locationExist)
      return Center(child: Text('getting your location.....'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    mapBloc.add(OnLocationUpdate(state.location));

    final cameraPosition = CameraPosition(target: state.location, zoom: 15);

    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return GoogleMap(
        initialCameraPosition: cameraPosition,
        //podemos crear un boton para cambiar el tipo de mapa con enum
        mapType: MapType.normal,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        polylines: mapBloc.state.polylines.values.toSet(),
        onCameraMove: (cameraPosition) {
          mapBloc.add(OnMapMove(cameraPosition.target));
        },
        onMapCreated: (GoogleMapController controller) {
          mapBloc.initMap(controller);
        },
      );
    });
  }
}

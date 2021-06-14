import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:map_app/providers/cubic/map/map_bloc.dart';
import 'package:map_app/providers/cubic/markers/marker_bloc.dart';
import 'package:map_app/services/marker_repository.dart';
import 'package:map_app/services/marker_service.dart';
import 'package:map_app/widgets/CoordinateCard.dart';
import 'package:provider/provider.dart';

class CirclePointsView extends StatefulWidget {
  @override
  _CirclePointsViewState createState() => _CirclePointsViewState();
}

class _CirclePointsViewState extends State<CirclePointsView> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    fetchPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkersService>(builder: (context, marker, child) {
      return Scaffold(
        key: scaffoldKey,
        body: pointAndPlaceView(marker, context),
      );
    });

    // Scaffold(
    //     key: scaffoldKey,
    //     body: Consumer<MarkersService>(
    //       builder: (BuildContext context, marker, Widget child) {
    //         fetchPoints(context);
    //         return pointAndPlaceView(marker, context);
    //       },
    //     ));
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (context) => PointsCubit(mapService)),
    //     BlocProvider(create: (context) => LineCubit()),
    //   ],
    //   child: buildScaffoldBody(),
    // );
  }

  void fetchPoints() {
    Future.microtask(() {
      Provider.of<MarkersService>(context, listen: false).getMarkers();
      // context.read<PointsCubit>().fetchPoints();
    });
  }

  Widget pointAndPlaceView(MarkersService completed, BuildContext context) {
    return Stack(
      children: [
        pointsList(completed, context),
        positionedPageView(context, completed),
      ],
    );
  }

  Positioned positionedPageView(BuildContext context, MarkersService marker) {
    return Positioned(
      height: MediaQuery.of(context).size.height * 0.12,
      bottom: 0,
      right: 0,
      left: -MediaQuery.of(context).size.width * 0.1,
      child: PageView.builder(
        onPageChanged: (value) {
          Provider.of<MapService>(context, listen: false)
              .changeMarker(value, marker.coordinates[value]);
          marker.setSelectedItem(value);
        },
        itemCount: marker.coordinates.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) =>
            CoordinateCard(coordinate: marker.coordinates[index]),
      ),
    );
  }

  Widget pointsList(MarkersService completed, BuildContext context) {
    final coordinates = completed.coordinates;
    //final marker = Provider.of<MarkersService>(context, listen: false);
    return Consumer<MapService>(
      builder: (BuildContext context, map, Widget child) {
        return GoogleMap(
          onMapCreated: (controller) {
            map.initMapController(controller);
          },
          markers: Set.from(coordinates.map((e) => markerCreate(e, context,
              e == completed.coordinates[completed.selectedItem ?? 0]))),
          initialCameraPosition:
              CameraPosition(target: coordinates.first.coordinates, zoom: 15),
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        );
      },
    );

    //   BlocConsumer<LineCubit, LineState>(
    //   listener: (context, LineState state) {},
    //   builder: (context, state) => GoogleMap(
    //     onMapCreated: (controller) {
    //       context.read<LineCubit>().initMapController(controller);
    //     },
    //     markers: Set.from(coordinates.map((e) => markerCreate(
    //         e, context, e == completed.coordinates[state.currentIndex]))),
    //     initialCameraPosition:
    //         CameraPosition(target: coordinates.first.coordinate, zoom: 15),
    //     mapType: MapType.normal,
    //     compassEnabled: true,
    //     myLocationEnabled: true,
    //     myLocationButtonEnabled: false,
    //     zoomControlsEnabled: false,
    //   ),
    // );
  }

  Marker markerCreate(MapMarker e, BuildContext context, bool isSelected) {
    return Marker(
      markerId: MarkerId(e.name),
      position: e.coordinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange),
    );
  }
}

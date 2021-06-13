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

class CirclePointsView extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

  MarkerRepository get mapService =>
      MarkerService(FirebaseFirestore.instance, scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PointsCubit(mapService)),
        BlocProvider(create: (context) => LineCubit()),
      ],
      child: buildScaffoldBody(),
    );
  }

  Widget buildScaffoldBody() => Scaffold(
        key: scaffoldKey,
        body: BlocConsumer<PointsCubit, PointsState>(
          listener: (context, state) {
            if (state.runtimeType == PointsError) {
              scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text("Error")));
            } else if (state.runtimeType == PointsInitial) {
              context.read<PointsCubit>().fetchPoints();
            } else if (state.runtimeType == PointsCompleted) {}
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case PointsLoading:
                return CircularProgressIndicator();
              case PointsCompleted:
                return pointAndPlaceView(state, context);
              case PointsError:
                return Text((state as PointsError).message);
              default:
                fetchPoints(context);
                return CircularProgressIndicator();
            }
          },
        ),
      );

  void fetchPoints(BuildContext context) {
    Future.microtask(() {
      context.read<PointsCubit>().fetchPoints();
    });
  }

  Widget pointAndPlaceView(PointsCompleted completed, BuildContext context) {
    return Stack(
      children: [
        pointsList(completed, context),
        positionedPageView(context, completed),
      ],
    );
  }

  Positioned positionedPageView(
      BuildContext context, PointsCompleted completed) {
    return Positioned(
      height: MediaQuery.of(context).size.height * 0.12,
      bottom: 0,
      right: 0,
      left: -MediaQuery.of(context).size.width * 0.1,
      child: PageView.builder(
        onPageChanged: (value) {
          context
              .read<LineCubit>()
              .changeMarker(value, completed.coordinates[value]);
        },
        itemCount: completed.coordinates.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) =>
            CoordinateCard(coordinate: completed.coordinates[index]),
      ),
    );
  }

  Widget pointsList(PointsCompleted completed, BuildContext context) {
    final coordinates = completed.coordinates;
    return BlocConsumer<LineCubit, LineState>(
      listener: (context, LineState state) {},
      builder: (context, state) => GoogleMap(
        onMapCreated: (controller) {
          context.read<LineCubit>().initMapController(controller);
        },
        markers: Set.from(coordinates.map((e) => markerCreate(
            e, context, e == completed.coordinates[state.currentIndex]))),
        initialCameraPosition:
            CameraPosition(target: coordinates.first.coordinate, zoom: 15),
        mapType: MapType.normal,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }

  Marker markerCreate(MapMarker e, BuildContext context, bool isSelected) {
    return Marker(
      markerId: MarkerId(e.name),
      position: e.coordinate,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange),
    );
  }
}

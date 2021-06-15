import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/providers/map/map_bloc.dart';
import 'package:map_app/providers/markers/marker_bloc.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markerService = Provider.of<MarkersService>(context);
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          buildMap(),
          // Positioned(
          //   height: MediaQuery.of(context).size.height * 0.12,
          //   bottom: 0,
          //   right: 0,
          //   left: -MediaQuery.of(context).size.width * 0.1,
          //   child:
          //   PageView.builder(
          //     onPageChanged: (value) {
          //       Provider.of<MapService>(context, listen: false)
          //           .changeMarker(value, markerService.coordinates[value]);
          //       markerService.setSelectedItem(value);
          //     },
          //     itemCount: markerService.coordinates.length,
          //     controller: PageController(viewportFraction: 0.8),
          //     itemBuilder: (context, index) =>
          //         CoordinateCard(coordinate: markerService.coordinates[index]),
          //   ),
          // ),
        ],
      ),
    );

    // return Consumer<MarkersService>(builder: (context, marker, child) {
    //   return Scaffold(
    //       key: scaffoldKey,
    //       body:
    //
    //       StreamBuilder<List<MapMarker>>(
    //         stream: Provider.of<MainScreenService>(context).markerStream,
    //         builder: (BuildContext context,
    //             AsyncSnapshot<List<MapMarker>> snapshot) {
    //           if (snapshot.hasError)
    //             return Center(child: Text('Error: ${snapshot.error}'));
    //           switch (snapshot.connectionState) {
    //             case ConnectionState.waiting:
    //               return Text('Loading...');
    //             default:
    //               return pointAndPlaceView(marker, context);
    //             // if (snapshot.hasData) {
    //             //   final List<MapMarker> coordinates = snapshot.data;
    //             //   return pointAndPlaceView(marker, context);
    //             // }
    //             // switch (snapshot.connectionState) {
    //             //   case ConnectionState.waiting:
    //             //     return Center(child: CircularProgressIndicator());
    //             //   default:
    //             //     return Center(child: CircularProgressIndicator());
    //           }
    //         },
    //       ));
    // });
  }

  // void fetchPoints() {
  //   Future.microtask(() {
  //     Provider.of<MarkersService>(context, listen: false).fetchMarkers();
  //   });
  // }

  // Widget pointAndPlaceView(MarkersService completed, BuildContext context) {
  //   return Stack(
  //     children: [
  //       pointsList(completed, context),
  //       positionedPageView(context, completed),
  //     ],
  //   );
  // }

  Widget buildMap() {
    final CameraPosition _initialcameraposition = CameraPosition(
      target: LatLng(41, -3.5),
      zoom: 5,
    );
    final markerService = Provider.of<MarkersService>(context);
    final List<Marker> allMarkers = markerService.coordinates;
    final mapService = Provider.of<MapService>(context);
    // if (!mapService.locationExist) {
    //   return Center(
    //     child: Text('Getting your location....'),
    //   );
    // } else if (mapService.currentPosition != null) {
    //   mapService.setLocationExist(true);
    //   final cameraPosition = CameraPosition(
    //       target: LatLng(mapService.currentPosition.latitude,
    //           mapService.currentPosition.longitude),
    //       zoom: 15);
    return GoogleMap(
      //       onLongPress: (controller) {
      // showDialog(
      // context: context,
      // builder: (BuildContext context) {
      // return AlertDialog(
      // content: Container(
      // padding: EdgeInsets.all(10),
      // child: AddCoordinates(
      // coordinates: controller,
      // ),
      // ),
      // shape: RoundedRectangleBorder(
      // borderRadius: BorderRadius.all(Radius.circular(2.0))),
      // );
      // },
      // );
      // },
      onMapCreated: (controller) {
        mapService.initMap(controller);
      },
      markers: Set.from(allMarkers.map((e) => markerCreate(
          e, context, e == allMarkers[markerService.selectedItem ?? 0]))),
      initialCameraPosition: _initialcameraposition,
      // CameraPosition(
      //   target: LatLng(41, -3.5),
      //   zoom: 5,
      // ),
      mapType: MapType.normal,
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  // final cameraPosition = CameraPosition(
  //     target: LatLng(mapService.currentPosition.latitude,
  //         mapService.currentPosition.longitude),
  //     zoom: 15);

  // return GoogleMap(
  //   //       onLongPress: (controller) {
  //   // showDialog(
  //   // context: context,
  //   // builder: (BuildContext context) {
  //   // return AlertDialog(
  //   // content: Container(
  //   // padding: EdgeInsets.all(10),
  //   // child: AddCoordinates(
  //   // coordinates: controller,
  //   // ),
  //   // ),
  //   // shape: RoundedRectangleBorder(
  //   // borderRadius: BorderRadius.all(Radius.circular(2.0))),
  //   // );
  //   // },
  //   // );
  //   // },
  //   onMapCreated: (controller) {
  //     mapService.initMap(controller);
  //   },
  //   markers: Set.from(allMarkers.map((e) => markerCreate(
  //       e, context, e == allMarkers[markerService.selectedItem ?? 0]))),
  //   initialCameraPosition: cameraPosition,
  //   mapType: MapType.normal,
  //   compassEnabled: true,
  //   myLocationEnabled: true,
  //   myLocationButtonEnabled: false,
  //   zoomControlsEnabled: false,
  // );
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

// Widget pointsList(MarkersService completed, BuildContext context) {
//   final coordinates = completed.coordinates;
//   return Consumer<MapService>(
//     builder: (BuildContext context, map, Widget child) {
//       return GoogleMap(
//         onLongPress: (controller) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: Container(
//                   padding: EdgeInsets.all(10),
//                   child: AddCoordinates(
//                     coordinates: controller,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(2.0))),
//               );
//             },
//           );
//         },
//         onMapCreated: (controller) {
//           map.initMapController(controller);
//         },
//         markers: Set.from(coordinates.map((e) => markerCreate(e, context,
//             e == completed.coordinates[completed.selectedItem ?? 0]))),
//         initialCameraPosition:
//             CameraPosition(target: LatLng(41.3828939, 2.1774322), zoom: 15),
//         mapType: MapType.normal,
//         compassEnabled: true,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: false,
//         zoomControlsEnabled: false,
//       );
//     },
//   );
// }

//coordinates.first.coordinates
Marker markerCreate(Marker e, BuildContext context, bool isSelected) {
  return Marker(
    markerId: MarkerId(e.markerId.toString()),
    position: e.position,
    icon: BitmapDescriptor.defaultMarkerWithHue(
        isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange),
  );
}
//}

class AddCoordinates extends StatefulWidget {
  final LatLng coordinates;

  AddCoordinates({Key key, this.coordinates}) : super(key: key);

  @override
  AddCoordinatesState createState() => AddCoordinatesState();
}

class AddCoordinatesState extends State<AddCoordinates> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  //final db = FirebaseFirestore.instance;

  // Future<MapMarker> postMarker() async {
  //   await db
  //       .collection('markers')
  //       .add({
  //         'name': _nameController.text,
  //         'lat': double.parse(widget.coordinates.longitude.toStringAsFixed(6)),
  //         'lng': double.parse(widget.coordinates.latitude.toStringAsFixed(6)),
  //       })
  //       .then((value) => {
  //             Future.microtask(() {
  //               Provider.of<MarkersService>(context, listen: false)
  //                   .fetchMarkers();
  //               // context.read<PointsCubit>().fetchPoints();
  //             }),
  //             ScaffoldMessenger.of(context)
  //                 .showSnackBar(SnackBar(content: Text('Saved')))
  //           })
  //       .catchError((error) => {
  //             ScaffoldMessenger.of(context)
  //                 .showSnackBar(SnackBar(content: Text('Error !!')))
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    final markerService = Provider.of<MarkersService>(context);
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child:
                Text("Longitude: " + widget.coordinates.longitude.toString()),
          ),
          Container(
            child: Text("Latitude: " + widget.coordinates.latitude.toString()),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> data = {
                            'name': _nameController.text,
                            'lat': double.parse(widget.coordinates.longitude
                                .toStringAsFixed(6)),
                            'lng': double.parse(
                                widget.coordinates.latitude.toStringAsFixed(6)),
                          };
                          await markerService.addMarkerToFirestore(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saving marker')));
                          //await postMarker();
                        } else {}
                      },
                      child: Text('Save'),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
//
// //My imports
// import 'package:map_app/models/marker.dart';
// import 'package:map_app/widgets/CoordinateCard.dart';
//
// class CirclePointsView extends StatefulWidget {
//   @override
//   _CirclePointsViewState createState() => _CirclePointsViewState();
// }
//
// class _CirclePointsViewState extends State<CirclePointsView> {
//   final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();
//   List<MapMarker> allMarkers = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MarkersService>(builder: (context, marker, child) {
//       final mapService = Provider.of<MapService>(context);
//       return Scaffold(
//           extendBodyBehindAppBar: false,
//           key: scaffoldKey,
//           appBar: AppBar(
//             centerTitle: true,
//             title: RichText(
//                 text: TextSpan(
//                     text: "Carrots",
//                     style: TextStyle(
//                         color: Colors.deepOrange,
//                         fontSize: 30.0,
//                         fontWeight: FontWeight.bold),
//                     children: [
//                   TextSpan(
//                       text: " Lab",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold))
//                 ])),
//             backgroundColor: Colors.transparent,
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.my_location),
//                 onPressed: () => mapService
//                     .moveCamera(Provider.of<LocationService>(context).location),
//               )
//             ],
//           ),
//           body: FutureBuilder<List<MapMarker>>(
//             //initialData: [],
//             future: marker.fetchMarkers(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 allMarkers = snapshot.data;
//                 return _pointsAndPlaceView(marker, context);
//               }
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                 default:
//                   return Center(child: CircularProgressIndicator());
//               }
//             },
//           ));
//     });
//   }
//
//   Stack _pointsAndPlaceView(MarkersService marker, BuildContext context) {
//     return Stack(
//       children: [
//         _googleMap(marker),
//         _listOfMarkers(context, marker),
//         _saveButton,
//       ],
//     );
//   }
//
//   Positioned _listOfMarkers(BuildContext context, MarkersService marker) {
//     return Positioned(
//       height: MediaQuery.of(context).size.height * 0.12,
//       bottom: 0,
//       right: 0,
//       left: -MediaQuery.of(context).size.width * 0.1,
//       child: PageView.builder(
//         onPageChanged: (value) {
//           Provider.of<MapService>(context, listen: false)
//               .changeMarker(value, marker.coordinates[value]);
//           marker.setSelectedItem(value);
//         },
//         itemCount: marker.coordinates.length,
//         controller: PageController(viewportFraction: 0.8),
//         itemBuilder: (context, index) =>
//             CoordinateCard(coordinate: marker.coordinates[index]),
//       ),
//     );
//   }
//
//   Consumer<MapService> _googleMap(MarkersService marker) {
//     return Consumer<MapService>(
//       builder: (BuildContext context, map, Widget child) {
//         final locationService = Provider.of<LocationService>(context);
//         final coordinates = marker.coordinates;
//         return GoogleMap(
//           onMapCreated: (controller) {
//             map.initMap(controller);
//           },
//           onLongPress: (pos) {
//             print(pos);
//             marker.addMarker(pos);
//             _saveButton;
//           },
//           //onCameraMove: (position) => marker.clearPoint(),
//           markers: Set.from(coordinates.map((e) => markerCreate(
//               e, context, e == marker.coordinates[marker.selectedItem ?? 0]))),
//           initialCameraPosition:
//               CameraPosition(target: LatLng(41.3828939, 2.1774322), zoom: 15),
//           mapType: MapType.normal,
//           compassEnabled: true,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//         );
//       },
//     );
//   }
//
//   Marker markerCreate(MapMarker e, BuildContext context, bool isSelected) {
//     return Marker(
//       markerId: MarkerId(e.name),
//       position: e.coordinates,
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//           isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange),
//     );
//   }
//
//   Widget get _saveButton {
//     final markerService = Provider.of<MarkersService>(context, listen: false);
//     return Positioned(
//       top: 60.0,
//       right: 10.0,
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 500),
//         opacity: markerService.point != null ? 1 : 0,
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   content: Container(
//                     padding: EdgeInsets.all(10),
//                     child: AddCoordinates(
//                       coordinates: LatLng(41.3828939, 2.1774322),
//                     ),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(2.0))),
//                 );
//               },
//             );
//             // Map<String, dynamic> data = {
//             //   'lat': markerService.point.position.longitude,
//             //   'lng': markerService.point.position.latitude,
//             //   'name': 'hello'
//             // };
//             // markerService.addMarkerToFirestore(data);
//           },
//           child: Row(
//             children: [
//               SizedBox(width: 22),
//               Text('SAVE'),
//               Icon(
//                 Icons.arrow_right_rounded,
//                 size: 44,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AddCoordinates extends StatefulWidget {
//   final LatLng coordinates; // receives the value
//
//   AddCoordinates({Key key, this.coordinates}) : super(key: key);
//
//   @override
//   AddCoordinatesState createState() => AddCoordinatesState();
// }
//
// class AddCoordinatesState extends State<AddCoordinates> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   // final  db = FirebaseFirestore.instance;
//   //
//   //
//   //
//   // Future<MapMarker> postMarker() async {
//   //   await db.collection('markers')
//   //       .add({
//   //     'name': _nameController.text,
//   //     'lat': double.parse(widget.coordinates.longitude.toStringAsFixed(6)) ,
//   //     'lng': double.parse(widget.coordinates.latitude.toStringAsFixed(6)) ,
//   //   })
//   //       .then((value) => {
//   //     Future.microtask(() {
//   //       Provider.of<MarkersService>(context, listen: false).getMarkers();
//   //       // context.read<PointsCubit>().fetchPoints();
//   //     }),
//   //     ScaffoldMessenger.of(context)
//   //         .showSnackBar(SnackBar(content: Text('Saved')))
//   //   })
//   //       .catchError((error) => {
//   //     ScaffoldMessenger.of(context)
//   //         .showSnackBar(SnackBar(content: Text('Error !!')))
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final markerService = Provider.of<MarkersService>(context);
//     return Container(
//       height: 200,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Container(
//             child:
//                 Text("Longitude: " + widget.coordinates.longitude.toString()),
//           ),
//           Container(
//             child: Text("Latitude: " + widget.coordinates.latitude.toString()),
//           ),
//           Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Container(
//                     child: TextFormField(
//                       controller: _nameController,
//                       // The validator receives the text that the user has entered.
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter name';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Container(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Validate returns true if the form is valid, or false otherwise.
//                         if (_formKey.currentState.validate()) {
//                           Map<String, dynamic> data = {
//                             'name': _nameController.text,
//                             'lat': double.parse(widget.coordinates.longitude
//                                 .toStringAsFixed(6)),
//                             'lng': double.parse(
//                                 widget.coordinates.latitude.toStringAsFixed(6)),
//                           };
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Saving marker')));
//                           await
//                               //postMarker();
//
//                               markerService.addMarkerToFirestore(data);
//                         } else {}
//                       },
//                       child: Text('Save'),
//                     ),
//                   )
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }

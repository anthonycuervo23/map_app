import 'package:flutter/material.dart';
import 'package:map_app/providers/markers/marker_bloc.dart';

import 'package:map_app/widgets/CoordinateCard.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrots LAP Map app'),
      ),
      body: Center(child: MarkersList()),
    );
  }
}

class MarkersList extends StatefulWidget {
  @override
  MarkersListState createState() => MarkersListState();
}

class MarkersListState extends State<MarkersList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarkersService>(builder: (context, marker, child) {
      return new ListView.builder(
          itemCount: marker.coordinates.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return (CoordinateCard(coordinate: marker.coordinates[index]));
          });
    });
  }
}

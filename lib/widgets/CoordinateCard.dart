import 'package:flutter/material.dart';

//My imports
import 'package:map_app/models/marker.dart';

class CoordinateCard extends StatelessWidget {
  final MapMarker coordinate;
  const CoordinateCard({
    Key key,
    @required this.coordinate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(coordinate.name),
        trailing: Icon(Icons.navigation_sharp),
        subtitle: Text("${coordinate.lat} - ${coordinate.long}"),
      ),
    );
  }
}

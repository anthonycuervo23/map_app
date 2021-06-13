import 'package:flutter/material.dart';

//My imports
import 'package:map_app/core/routes.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrots LAP Map app'),
      ),
      body: Center(
        child: Text('MAP SCREEN'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites)),
    );
  }
}

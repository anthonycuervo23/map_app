import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//My imports
import 'package:map_app/models/marker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// class CoordinateCard extends StatelessWidget {
//   final MapMarker coordinate;
//   const CoordinateCard({
//     Key key,
//     @required this.coordinate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(coordinate.name),
//         trailing: Icon(Icons.navigation_sharp),
//         subtitle: Text("${coordinate.lat} - ${coordinate.long}"),
//       ),
//     );
//   }
// }

class CoordinateCard extends StatefulWidget {
  final Marker coordinate;
  CoordinateCard({Key key, @required this.coordinate}) : super(key: key);

  @override
  CoordinateCardState createState() => CoordinateCardState();
}

class CoordinateCardState extends State<CoordinateCard> {
  var weather = [];

  @override
  void initState() {
    fetchWeather();
  }

  Future fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.coordinate.position.longitude}&lon=${widget.coordinate.position.latitude}&appid=a7e029ae76daf0951c937dd71421c6b0'));

    var jsonData = jsonDecode(response.body);
    this.setState(() {
      weather = jsonData['weather'];
    });
  }

  Widget listItem() {
    return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.coordinate.infoWindow.title),
            this.weather.length == 0 ? Text("") : Text(this.weather[0]['main'])
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "${widget.coordinate.position.latitude} - ${widget.coordinate.position.longitude}"),
            this.weather.length == 0
                ? Text("")
                : Text(this.weather[0]['description'])
          ],
        ),
        trailing: Image.network(
            'https://openweathermap.org/img/w/${this.weather.length == 0 ? "01d" : this.weather[0]["icon"]}.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: listItem());
  }
}

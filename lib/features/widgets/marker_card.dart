import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/core/repository/map_repository.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:http/http.dart' as http;
import 'package:map_app/features/widgets/marker_card_design.dart';
import 'package:provider/provider.dart';

class MarkerCard extends StatefulWidget {
  const MarkerCard({Key key}) : super(key: key);

  @override
  _MarkerCardState createState() => _MarkerCardState();
}

class _MarkerCardState extends State<MarkerCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markerRepository = context.watch<MarkerRepository>();
    List<Marker> clients = markerRepository.markers;
    return Container(
      height: 125.0,
      width: MediaQuery.of(context).size.width,
      child: markerRepository.markersToggle
          ? PageView.builder(
              onPageChanged: (value) {
                markerRepository.setCurrentMarker(clients[value]);
                markerRepository.setCurrentBearing(90.0);
                zoomInMarker(clients[value]);
              },
              itemCount: clients.length,
              controller: PageController(viewportFraction: 0.8),
              itemBuilder: (context, index) =>
                  MarkerListTile(currentMarker: clients[index]),
            )
          : Container(),
    );
  }

  zoomInMarker(client) {
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(client.position.latitude, client.position.longitude),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      context.read<MarkerRepository>().setResetToggle(true);
    });
  }
}

class MarkerListTile extends StatefulWidget {
  final Marker currentMarker;
  const MarkerListTile({Key key, @required this.currentMarker})
      : super(key: key);

  @override
  _MarkerListTileState createState() => _MarkerListTileState();
}

class _MarkerListTileState extends State<MarkerListTile> {
  var weather = {};

  @override
  void initState() {
    fetchWeather();
    super.initState();
  }

  Future fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.currentMarker.position.latitude}&lon=${widget.currentMarker.position.longitude}&appid=a7e029ae76daf0951c937dd71421c6b0&units=metric'));

    var jsonData = jsonDecode(response.body);
    this.setState(() {
      weather = jsonData;
    });
    return weather;
  }

  String getWeatherSVGNetwork(int condition) {
    if (condition < 300) {
      // return SvgPicture.asset('images/storm.svg', width: 70, height: 70,);
      return 'https://www.flaticon.com/svg/static/icons/svg/3026/3026385.svg';
    } else if (condition < 400) {
      // return SvgPicture.asset('images/rain.svg', width: 70, height: 70,);
      return 'https://www.flaticon.com/svg/static/icons/svg/899/899693.svg';
    } else if (condition < 600) {
      // return SvgPicture.asset('images/umbrella.svg️', width: 70, height: 70,);
      return 'https://www.flaticon.com/svg/static/icons/svg/2921/2921803.svg';
    } else if (condition < 700) {
      // return SvgPicture.asset('images/snowflake.svg'️, width: 70, height: 70,);
      return 'https://www.flaticon.com/svg/static/icons/svg/2834/2834554.svg';
    } else if (condition < 800) {
      // return SvgPicture.asset('images/fog.svg', width: 70, height: 70,);
      return 'https://www.flaticon.com/svg/static/icons/svg/2446/2446001.svg';
    } else if (condition == 800) {
      return 'https://www.flaticon.com/svg/static/icons/svg/146/146199.svg';
    } else if (condition <= 804) {
      // return 'images/cloud.svg️';
      return 'https://www.flaticon.com/svg/static/icons/svg/899/899681.svg';
    } else {
      // return '🤷‍';
      return 'https://www.flaticon.com/svg/static/icons/svg/2471/2471920.svg';
    }
  }

  Widget clientCard() {
    double tempDouble = this.weather['main']['temp'];
    int temp = tempDouble.round();
    return MarkerCardDesign(
      markerName: widget.currentMarker.infoWindow.title,
      coordinates:
          '${widget.currentMarker.position.latitude}, ${widget.currentMarker.position.longitude.toStringAsFixed(6)}',
      temp: '$temp° C',
      weather: this.weather['weather'][0]['description'],
      image: getWeatherSVGNetwork(this.weather['weather'][0]['id']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return clientCard();
  }
}

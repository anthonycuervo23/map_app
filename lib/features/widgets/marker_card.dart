part of 'widgets.dart';

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
    List<MarkerModel> clients = markerRepository.customMarkers;
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

  zoomInMarker(MarkerModel client) {
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(client.latitude, client.longitude),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      context.read<MarkerRepository>().setResetToggle(true);
    });
  }
}

class MarkerListTile extends StatefulWidget {
  final MarkerModel currentMarker;
  const MarkerListTile({Key key, @required this.currentMarker})
      : super(key: key);

  @override
  _MarkerListTileState createState() => _MarkerListTileState();
}

class _MarkerListTileState extends State<MarkerListTile> {
  var weather = {};

  @override
  void initState() {
    //fetchWeather();
    super.initState();
  }

  Widget clientCard() {
    return MarkerCardDesign(
      markerName: widget.currentMarker.name,
      coordinates:
          '${widget.currentMarker.latitude}, ${widget.currentMarker.longitude.toStringAsFixed(6)}',
      temp: '${widget.currentMarker.weather.main.temp.round()}° C',
      weather: widget.currentMarker.weather.weather[0].description,
      image: WeatherModel()
          .getWeatherSVGNetwork(widget.currentMarker.weather.weather[0].id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return clientCard();
  }
}

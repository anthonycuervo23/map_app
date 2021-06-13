part of 'widgets.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state.manualSelection) {
        return _BuildMarker();
      } else {
        return Container();
      }
    });
  }
}

class _BuildMarker extends StatelessWidget {
  const _BuildMarker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: CircleAvatar(
            maxRadius: 25,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                context.read<SearchBloc>().add(OnMarkerDeactivated());
              },
            ),
          ),
        ),
        Center(
          child: Transform.translate(
              offset: Offset(0, -12),
              child: BounceInDown(child: Icon(Icons.location_on, size: 50))),
        ),
        Positioned(
            bottom: 70,
            left: 40,
            child: MaterialButton(
              minWidth: size.width - 120,
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              child: Text(
                'Confirm destination',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                this.routeCalculation(context);
              },
            )),
      ],
    );
  }

  void routeCalculation(BuildContext context) async {
    calculatingAlert(context);

    final mapBloc = context.read<MapBloc>();
    final trafficService = TrafficService();

    final start = context.read<LocationBloc>().state.location;
    final end = mapBloc.state.centralLocation;

    final routeResponse =
        await trafficService.getStartAndEndCoordinates(start, end);

    final duration = routeResponse.routes[0].duration;
    final distance = routeResponse.routes[0].distance;
    final geometry = routeResponse.routes[0].geometry;

    //Decodificamos los puntos de geometry para calcular rutas
    final result = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> points =
        result.map((point) => LatLng(point[0], point[1])).toList();

    mapBloc.add(OnCreateRoute(points, distance, duration));

    Navigator.of(context).pop();

    context.read<SearchBloc>().add(OnMarkerDeactivated());
  }
}

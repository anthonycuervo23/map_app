part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (!state.manualSelection) {
        return _BuildSearchBar();
      } else {
        return Container();
      }
    });
  }
}

class _BuildSearchBar extends StatelessWidget {
  const _BuildSearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: size.width,
        child: GestureDetector(
          onTap: () async {
            final proximity = context.read<LocationBloc>().state.location;

            final result = await showSearch(
                context: context, delegate: SearchDestination(proximity));
            this.returnSearch(context, result);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text(
              'Where are we going today?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> returnSearch(BuildContext context, SearchResult result) async {
    if (result.cancel) return;
    if (result.manual) {
      context.read<SearchBloc>().add(OnMarkerActivated());
      return;
    }

    calculatingAlert(context);

    //calculamos la ruta de acuerdo al resultado de la busqueda
    final trafficService = TrafficService();
    final mapBloc = context.read<MapBloc>();

    final start = context.read<LocationBloc>().state.location;
    final end = result.position;

    final drivingResponse =
        await trafficService.getStartAndEndCoordinates(start, end);

    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;

    final startedPoints =
        Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> points = startedPoints.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();

    mapBloc.add(OnCreateRoute(points, distance, duration));

    Navigator.of(context).pop();
  }
}

part of 'widgets.dart';

class BtnAddBearing extends StatefulWidget {
  const BtnAddBearing({Key key}) : super(key: key);

  @override
  _BtnAddBearingState createState() => _BtnAddBearingState();
}

class _BtnAddBearingState extends State<BtnAddBearing> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.green,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.rotate_right,
              color: Colors.black87,
            ),
            onPressed: addBearing),
      ),
    );
  }

  addBearing() {
    final markerRepository = context.read<MarkerRepository>();
    context
        .read<MapRepository>()
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(markerRepository.currentMarker.latitude,
                markerRepository.currentMarker.longitude),
            bearing: markerRepository.currentBearing == 360.0
                ? markerRepository.currentBearing
                : markerRepository.currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      if (markerRepository.currentBearing == 360.0) {
      } else {
        markerRepository
            .setCurrentBearing(markerRepository.currentBearing + 90);
      }
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/generated/l10n.dart';
import 'package:map_app/screens/add_marker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.9398655999999999, 30.1006848),
    zoom: 15.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-1.9398655999999999, 30.1006848),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var addresses;
  var first;
  bool show = false;
  bool visible = true;
  bool isClicked = false;
  double lat;
  double long;
  double initlat;
  double initlong;
  String key = '5f0272b3811079bcfe74364d35f2c94e';
  String weather;
  String desc;
  String cityName = 'Kongens Lyngby';
  WeatherFactory ws;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Set<Marker> _makers = {};
  bool isLoading = false;

  final _firestore = FirebaseFirestore.instance;

  Future getMarkers() async {
    await _firestore
        .collection('markers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _makers.add(
            Marker(
              onTap: () {
                print('Tapped');
              },
              draggable: false,
              infoWindow: InfoWindow(
                title: doc["name"],
              ),
              markerId: MarkerId(doc["name"]),
              position: LatLng(doc["lat"], doc["long"]),
              visible: true,
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        });
      });
    });
  }

  Future getLocation() async {
    setState(() {
      isLoading = true;
    });
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.altitude);
    setState(() {
      initlat = _locationData.latitude;
      initlong = _locationData.longitude;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    getMarkers();
    ws = new WeatherFactory(key);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: RichText(
            text: TextSpan(
                text: "CARROTS",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: " Map",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold))
            ])),
        centerTitle: true,
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () async {
              await getLocation();
              await getMarkers();
            },
            icon: Icon(
              Icons.my_location_rounded,
            ),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Container(
          color: Colors.white,
          width: size.width * 0.65,
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("markers").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                }
                List<Widget> markersList = [
                  Container(
                    width: size.width * 0.65,
                    height: size.height * 0.15,
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        "Markers",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ];
                final data = snapshot.data!.docs;
                for (var marker in data) {
                  markersList.add(
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.pin_drop_rounded,
                            size: 30,
                          ),
                          title: Text(
                            marker['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          subtitle: Text(
                            marker['weather'],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await _firestore
                                  .collection("markers")
                                  .doc(marker.id)
                                  .delete();
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }
                return ListView(
                  children: markersList,
                );
              }),
        ),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onTap: (value) async {
                      Weather w = await ws.currentWeatherByLocation(
                          value.latitude, value.longitude);
                      print(w.temperature);
                      setState(() {
                        lat = value.latitude;
                        long = value.longitude;
                        weather = w.temperature.toString();
                        desc = w.weatherDescription;
                        isClicked = true;
                        _makers.clear();
                        _makers.add(
                          Marker(
                            onTap: () {
                              print('Tapped');
                            },
                            draggable: false,
                            infoWindow: InfoWindow(
                              title: desc,
                            ),
                            markerId: MarkerId('Marker'),
                            position: LatLng(value.latitude, value.longitude),
                            visible: true,
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        );
                      });
                    },
                    onLongPress: (value) {
                      setState(() {
                        isClicked = false;
                      });
                    },
                    mapType: MapType.terrain,
                    markers: _makers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(initlat!, initlong!),
                      zoom: 16.4746,
                    ),
                  ),
                  show
                      ? Positioned(
                          top: size.height * 0.02,
                          left: size.width * 0.02,
                          child: AnimatedOpacity(
                            opacity: visible ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              height: size.height * 0.15,
                              width: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Press and Hold a place on the map to mark it",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  isClicked
                      ? Positioned(
                          top: size.height * 0.02,
                          left: size.width * 0.02,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.0),
                                height: size.height * 0.14,
                                width: size.height * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        S.of(context).weather,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        desc!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        weather!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.15,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                child: ButtonTheme(
                                  height: size.height * 0.06,
                                  minWidth: size.width * 0.25,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    color: Colors.orange,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddMarker(
                                            lat: lat,
                                            long: long,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      S.of(context).save,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _globalKey.currentState!.openDrawer();
        },
        child: Icon(
          Icons.list_alt,
        ),
      ),
    );
  }
}

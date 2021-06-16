import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_app/generated/l10n.dart';
import 'package:weather/weather.dart';

class AddMarker extends StatefulWidget {
  final double lat;
  final double long;
  AddMarker({
    this.lat,
    this.long,
  });

  @override
  _AddMarkerState createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  TextEditingController name = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late WeatherFactory ws;
  String key = '5f0272b3811079bcfe74364d35f2c94e';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    if (widget.lat != null && widget.long != null) {
      latitude.text = widget.lat.toString();
      longitude.text = widget.long.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).appBarMarkers),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).nameRequired;
                          }
                          return null;
                        },
                        decoration: TextFieldDecoration(
                          Icon(Icons.pin_drop_rounded),
                          S.of(context).name,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextFormField(
                        controller: latitude,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).latitudeRequired;
                          }
                          return null;
                        },
                        decoration: TextFieldDecoration(
                          Icon(
                            Icons.location_on_sharp,
                          ),
                          S.of(context).latitude,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextFormField(
                        controller: longitude,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).longitudeRequired;
                          }
                          return null;
                        },
                        decoration: TextFieldDecoration(
                          Icon(
                            Icons.location_on_sharp,
                          ),
                          S.of(context).longitude,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        child: ButtonTheme(
                          height: size.height * 0.06,
                          minWidth: size.width,
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            color: Colors.orange,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                Weather w = await ws.currentWeatherByLocation(
                                  double.parse(widget.lat.toString()),
                                  double.parse(widget.long.toString()),
                                );
                                await FirebaseFirestore.instance
                                    .collection("markers")
                                    .doc()
                                    .set({
                                  "lat": double.parse(latitude.text),
                                  "long": double.parse(longitude.text),
                                  "name": name.text,
                                  "weather": w.weatherDescription,
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: deprecated_member_use
                                _globalKey.currentState!.showSnackBar(
                                  SnackBar(
                                    content: Text("Marker stored successfully"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              S.of(context).add,
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
                ),
        ),
      ),
    );
  }
}

class WeatherFactory {}

InputDecoration TextFieldDecoration(var prefix, String hint) {
  return InputDecoration(
    filled: true,
    prefixIcon: prefix,
    hintText: hint,
    border: new OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    ),
    enabledBorder: new OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
      borderSide: BorderSide.none,
    ),
    focusedBorder: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: Colors.orange,
        )),
  );
}

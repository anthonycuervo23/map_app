import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarkerCardDesign extends StatelessWidget {
  final String markerName;
  final String coordinates;
  final String temp;
  final String weather;
  final String image;

  MarkerCardDesign(
      {this.markerName, this.coordinates, this.temp, this.weather, this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 10.0,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              margin: EdgeInsets.only(left: 12.0),
              //constraints: BoxConstraints.expand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 20),
                  Text(markerName,
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text(coordinates),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 2.0,
                      width: 18.0,
                      color: Color(0xff00c6ff)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(temp,
                            style:
                                TextStyle(fontSize: 36, color: Colors.white)),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            weather,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            //height: 164.0,
            margin: EdgeInsets.only(top: 30.0),
            decoration: BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(8.0),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
                alignment: FractionalOffset.topRight,
                child: SvgPicture.network(
                  image,
                  width: 70,
                  height: 70,
                )),
          ),
        ],
      ),
    );
  }
}

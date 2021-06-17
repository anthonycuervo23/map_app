// import 'package:flutter/material.dart';

//my imports

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: Hero(
//         tag: 'logo',
//         child: Center(
//           child: Image.asset('assets/icon/logo_splash.png',
//               width: MediaQuery.of(context).size.width * 0.40),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    //getLocationData();
  }

  ///Use this screen to fetch markers
  // void getLocationData() async {
  //   final markerRepository = context.read<MarkerRepository>();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return HomeScreen(
  //           locationWeather: weatherData,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffafbd), Color(0xffffc3a0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              child: Image.asset('assets/icon/logo_splash.png'),
            ),
            Container(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

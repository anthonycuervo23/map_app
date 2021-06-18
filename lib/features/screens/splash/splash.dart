import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Hero(
        tag: 'logo',
        child: Center(
          child: Image.asset('assets/image/logo_splash.png',
              width: MediaQuery.of(context).size.width * 0.40),
        ),
      ),
    );
  }
}

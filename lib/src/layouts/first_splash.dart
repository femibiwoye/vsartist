import 'dart:async';
import 'package:flutter/material.dart';
import './../global/uidata.dart';
import 'package:vsartist/src/global/shared-data.dart';

class SplashPage extends StatefulWidget {
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() async {
    SharedData _pref = SharedData();
    if (await _pref.getScreenBaorded() == true) {
      if (await _pref.getisUserLogin() == true) {
        Navigator.of(context).pushReplacementNamed(UiData.dashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(UiData.login);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(UiData.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/images/splash.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

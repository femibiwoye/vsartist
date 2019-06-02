import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './global/uidata.dart';
import './global/routes.dart';
import 'package:vsartist/src/layouts/first_splash.dart';
import 'package:vsartist/src/notfound/notfound_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    // TODO: implement build
    return MaterialApp(
        title: UiData.appName,
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),
      routes: routes,
      onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
          builder: (context) => new NotFoundPage(
                appTitle: UiData.coming_soon,
                icon: Icons.tag_faces,
                title: UiData.notFound,
                message: "Under Development",
                iconColor: UiData.orange,
              )),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/global/uidata.dart';

class ServicesHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget services() => Container(
      padding: EdgeInsets.all(20),
          child: Center(
            child: ListView(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                new Text(
                  "Vibespot Music World",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.orange.shade700,
                  ),
                ),
                SizedBox(height: 17.0),
                new Text(
                  "For more promotional services like:",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.orange.shade700,
                  ),
                ),
                SizedBox(height: 30.0),

                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    '2D Animation Lyrics Videos',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Radio Promotion',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),

                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Tv Promotion',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),

                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Instagram and Facebook Ads',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Callertunes',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Growing of Instagram Account',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                new ListTile(
                  leading: new MyBullet(),
                  title: new Text(
                    'Youtube Ads',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                // SizedBox(20),
                new Text(
                  "Contact: 08060857859",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                new Text(
                  "Email: ifedee4sure@gmail.com",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
          ),
        );

    return ScaffoldCommon(
      appTitle: 'Services',
      bodyData: services(),
      showDrawer: false,
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 20.0,
      width: 20.0,
      decoration: new BoxDecoration(
        color: Colors.orange.shade700,
        shape: BoxShape.circle,
      ),
    );
  }
}

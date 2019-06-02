import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  Material homeText(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      heading,
                      style: TextStyle(
                        color: new Color(color),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardGridView() => new StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.signlesUpload);
            },
            child: homeText(Icons.album, "Singles Upload", 0xff26cb3c),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.albumUpload);
            },
            child: homeText(Icons.album, "Album Upload", 0xff26cb3c),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.myMusic);
            },
            child: homeText(Icons.library_music, "My Music", 0xff7297ff),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.myPlaylist);
            },
            child: homeText(Icons.graphic_eq, "Playlist", 0xffed622b),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.myBalance);
            },
            child: homeText(Icons.attach_money, "Balance", 0xff3399fe),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UiData.help);
            },
            child: homeText(Icons.help, "Help", 0xff26cb5b),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/');
          //   },
          //   child: homeText(Icons.show_chart, "Statistics", 0xff26cb3c),
          // ),

          // progressDialog
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          StaggeredTile.extent(1, 130.0),
          //StaggeredTile.extent(2, 120.0),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      appTitle: 'Dashboard',
      scaffoldState: scaffoldState,
      bodyData: dashboardGridView(),
      showDrawer: true,
    );
  }
}

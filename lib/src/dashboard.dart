import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/global/uidata.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  dashboardGridView() =>  Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Singles Upload", Icons.music_note, url:UiData.signlesUploadInstruction),
            makeDashboardItem("Album Upload", Icons.queue_music, url:UiData.albumUploadInstruction),
            makeDashboardItem("My Music", Icons.library_music, url: UiData.myMusic),
            makeDashboardItem("Playlist", Icons.graphic_eq),
            makeDashboardItem("Balance", Icons.attach_money, url: UiData.myBalance),
            makeDashboardItem("Help", Icons.info),
            makeDashboardItem("Services", Icons.work, url: UiData.servicesHome),
            makeDashboardItem("Statistics", Icons.show_chart)
          ],
        ),
      );

  // Widget dashboardGridView() => new StaggeredGridView.count(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 12.0,
  //       mainAxisSpacing: 12.0,
  //       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.signlesUploadInstruction);
  //           },
  //           child: homeText(Icons.album, "Singles Upload", 0xff26cb3c),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.albumUpload);
  //           },
  //           child: homeText(Icons.album, "Album Upload", 0xff26cb3c),
  //         ),

  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.myMusic);
  //           },
  //           child: homeText(Icons.library_music, "My Music", 0xff7297ff),
  //         ),

  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.myPlaylist);
  //           },
  //           child: homeText(Icons.graphic_eq, "Playlist", 0xffed622b),
  //         ),

  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.myBalance);
  //           },
  //           child: homeText(Icons.attach_money, "Balance", 0xff3399fe),
  //         ),

  //         GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(UiData.help);
  //           },
  //           child: homeText(Icons.help, "Help", 0xff26cb5b),
  //         ),
  //         // GestureDetector(
  //         //   onTap: () {
  //         //     Navigator.of(context).pushNamed('/');
  //         //   },
  //         //   child: homeText(Icons.show_chart, "Statistics", 0xff26cb3c),
  //         // ),

  //         // progressDialog
  //       ],
  //       staggeredTiles: [
  //         StaggeredTile.extent(1, 130.0),
  //         StaggeredTile.extent(1, 130.0),
  //         StaggeredTile.extent(1, 130.0),
  //         StaggeredTile.extent(1, 130.0),
  //         StaggeredTile.extent(1, 130.0),
  //         StaggeredTile.extent(1, 130.0),
  //         //StaggeredTile.extent(2, 120.0),
  //       ],
  //     );

  Card makeDashboardItem(String title, IconData icon, {url}) {
    return Card(
        elevation: 2.0,
        margin: new EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: new InkWell(
            onTap: () {
              if (url != null)
                Navigator.of(context)
                    .pushNamed(url);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 40.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: UiData.orange,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: UiData.orange)),
                )
              ],
            ),
          ),
        ));
  }

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

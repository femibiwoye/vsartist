import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'dart:async';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';

class MusicDetails extends StatelessWidget {
  final Music song;
  MusicDetails({this.song});
  @override
  Widget build(BuildContext context) {
    Widget list(title, value) => ListTile(
          title: new Text(title,
              style: new TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.normal,
                fontSize: 13.0,
                height: 1.0,
              )),
          subtitle: Text(value ?? '',
              style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
                height: 1.5,
              )),
        );
    Widget divider() => new Divider(height: 3.0, color: Colors.grey);

    Widget body()=>Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    list('Genre', song.genre),
                    divider(),
                    list('Description', song.description),
                    divider(),
                    list('Duration', song.duration),
                    list('Streamed', song.streamed),
                    divider(),
                    song.vibe_state != null && song.vibe_state.isNotEmpty
                        ? list('State Vibe', song.vibe_state)
                        : Container(),
                    song.vibe_state != null && song.vibe_state.isNotEmpty ? divider() : Container(),
                    song.push_state != null && song.push_state.isNotEmpty
                        ? list('Pushed State', song.push_state)
                        : Container(),
                    song.push_state != null && song.push_state.isNotEmpty ? divider() : Container(),
                    song.push_city != null && song.push_city.isNotEmpty
                        ? list('Pushed City', song.push_city)
                        : Container(),
                    song.push_city != null && song.push_city.isNotEmpty ? divider() : Container(),
                    list('Released Date', song.release_date),
                    divider(),
                    list(
                        'Verification Status',
                        song.verificationStatus == 1
                            ? 'Verified'
                            : 'Not Verified'),
                  ],
                )
              ]),
            );

    return ScaffoldCommon(
      showDrawer: false,
      bodyData: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: 150.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(song.title,
                                style: TextStyle(
                                  color:UiData.orange,
                                  fontSize: 18.0,
                                )),
                          ]),
                      background: Image.network(
                        song.image,
                        fit: BoxFit.cover,
                      )),
                )
              ];
            },
            body:body() 
          )),
    );
  }
}

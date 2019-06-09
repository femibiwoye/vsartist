import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:vsartist/src/music/music-bloc.dart';
import 'package:vsartist/src/music/music-functions.dart';
import 'package:vsartist/src/global/uidata.dart';

class MusicList extends StatefulWidget {
  final int id;
  final String type;
  final String title;
  MusicList({this.id, this.title, this.type});

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

var stream;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'album') {
      musicBloc.getAlbumList(widget.id);
      stream = musicBloc.allAlbumList;
    }else{
      stream = musicBloc.allReleaseList;
      musicBloc.getReleaseList(widget.id);
    }
  }

  list() => StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<List<Music>> snapshot) {
          if (snapshot.hasData) {
            return DecoratedBox(
              decoration: BoxDecoration(color: Colors.transparent),
              child: musicFunctions.buildSong(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UiData.orange)),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: widget.title ?? widget.type,
      bodyData: list(),
      showDrawer: false,
    );
  }
}

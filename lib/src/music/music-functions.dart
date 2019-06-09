import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/music/music-details.dart';
import 'package:vsartist/src/music/music-list.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';

class MusicFunctions {
  buildSong(List<Music> data) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  onTap: () {
                    print('album id is ${data[i].albumId}');
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new MusicDetails(song: data[i]);
                    }));
                  },
                  leading: new CircleAvatar(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.orangeAccent[700],
                    backgroundImage: data[i].image == null
                        ? new AssetImage(UiData.logo)
                        : new NetworkImage(data[i].image),
                  ),
                  title: new Text(data[i].title,
                      style: TextStyle(color: Colors.white)),
                  subtitle: new Text(
                    data[i].duration ?? data[1].description,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0),
                  ),
                  trailing: new Text(
                    data[i].genre,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ]),
    );
  }

  buildRelease(List<ReleaseSingle> data) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new MusicList(
                          id: data[i].releaseId,
                          type: 'release',
                          title: data[i].releaseName);
                    }));
                  },
                  title: new Text(data[i].releaseName,
                      style: TextStyle(color: Colors.white)),
                  subtitle: new Text(
                    data[i].releaseDate,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0),
                  ),
                  trailing: new Text(
                    data[i].tracksNumber,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ]),
    );
  }

  buildAlbum(List<UploadAlbumDetails> data) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new MusicList(
                          id: data[i].albumId,
                          type: 'album',
                          title: data[i].title);
                    }));
                  },
                  leading: new CircleAvatar(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.orangeAccent[700],
                    backgroundImage: data[i].image == null
                        ? new AssetImage(UiData.logo)
                        : new NetworkImage(data[i].image),
                  ),
                  title: new Text(data[i].title,
                      style: TextStyle(color: Colors.white)),
                  subtitle: new Text(
                    data[i].releaseDate,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0),
                  ),
                  trailing: new Text(
                    data[i].trackCount,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ]),
    );
  }
}

final musicFunctions = MusicFunctions();

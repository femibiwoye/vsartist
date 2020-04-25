import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/music/music-details.dart';
import 'package:vsartist/src/music/music-list.dart';
import 'package:vsartist/src/uploads/upload-payment.dart';
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
              title: new Text('${data[i].title}',
                  style: TextStyle(color: Colors.white)),
              subtitle: new Text(
                '${data[i].duration} (${data[i].streamed} streams)' ??
                    data[i].description,
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

  buildUnpublish(List data) {
    bool status;

    return new ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, i) {
          if (data[i]['paid_amount'] != null &&
              data[i]['payment_status'] == "1") {
            status = true;
          } else if (data[i]['type'] == 'release') {
            status = true;
          } else {
            status = false;
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  //onTap: () {
                  // if(data[i]['type'] == 'album')
                  // Navigator.of(context)
                  //     .push(new MaterialPageRoute(builder: (context) {
                  //   return new UploadPayment(
                  //     id: int.tryParse(data[i]['id']),
                  //     type: data[i]['type'],
                  //     isDrawer: false,
                  //     count: int.tryParse(data[i]['track_count']),
                  //   );
                  // }));
                  //},
                  title: new Text(
                      '${data[i]['title']} (${data[i]['track_count']})',
                      style: TextStyle(color: Colors.white)),
                  subtitle: new Text(
                    '${data[i]['type']} - ${data[i]['release_date']} - ${data[i]['amount_expected']}',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0),
                  ),
                  trailing: new Text(
                    'Yet Published',
                    style:
                        TextStyle(color: status ? Colors.grey : Colors.orange),
                  ),
                )
              ]);
        });
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
                      id: data[i].albumId, type: 'album', title: data[i].title);
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

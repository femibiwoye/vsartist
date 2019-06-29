import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:vsartist/src/uploads/uploads-model.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:path/path.dart' as path;
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:flutter/material.dart';
import 'package:vsartist/src/uploads/upload-payment.dart';

class UploadBloc {
  NetworkRequest network = new NetworkRequest();

  final _uploadSingles = PublishSubject<Music>();
  Observable<Music> get profile => _uploadSingles.stream;

  final _showProgress = PublishSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  final snackBar = PublishSubject<String>();
  Observable<String> get snacksBar => snackBar.stream;

  uploadSongs(UploadSingles upload, context) async {
    _showProgress.add(true);

    print(upload.toJson(upload));

    ReleaseSingle newSingles = ReleaseSingle.fromJson(upload.toJson(upload));
    Music music = new Music();

//newSingles = newSingles.(upload.tojson(upload));
    print(newSingles.toJson(newSingles));
    var response = await network.post(UiData.domain + "/songs/new-release",
        body: newSingles.toJson(newSingles),context: context);
    var res = jsonDecode(response);
    if (res['status']) {
      ReleaseSingle release = ReleaseSingle.fromJson(res['body']);
      print(release.releaseId.toString());
      print(release.amountExpected);
      for (var i = 0; i < upload.tracksNumber; i++) {
        upload.tracks[i].releaseId = release.releaseId.toString();
        print(upload.tracks[i].releaseId);
        print(music.toJson(upload.tracks[i]));
        FormData datas = new FormData.from(music.toJson(upload.tracks[i]));
        String response = await network
            .postWithFile(UiData.domain + "/songs/upload", body: datas);
        var decoded = jsonDecode(response);
        if (decoded["status"]) {
          if (i + 1 == upload.tracksNumber) {
            snackBar.add('$i track uploaded');
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return new UploadPayment(
                  id: release.releaseId,
                  count: upload.tracksNumber,
                  type: 'release',isDrawer: true);
            }));
          }
        } else if (decoded["error"] != null) {
          print(decoded["error"][0]);
          snackBar.add(decoded["error"][0] ?? 'You have invalid field');
          return;
        } else {
          snackBar.add('Something went wrong, please try again later.');
          return;
        }
      }
    }
  }

  uploadAlbum(UploadAlbum upload, context) async {
    _showProgress.add(true);
    print(upload.toJson(upload));
    UploadAlbumDetails newAlbum =
        UploadAlbumDetails.fromJson(upload.toJson(upload));
    Music music = new Music();

    var response = await network.post(UiData.domain + "/songs/new-album",
        body: newAlbum.toJson(newAlbum),context: context);

    var res = jsonDecode(response);

    if (res['status']) {
      UploadAlbumDetails release = UploadAlbumDetails.fromJson(res['body']);

      for (var i = 0; i < upload.trackCount; i++) {
        upload.tracks[i].albumId = release.albumId.toString();

        FormData datas = new FormData.from(music.toJson(upload.tracks[i]));

        String response = await network
            .postWithFile(UiData.domain + "/songs/album-tracks", body: datas);

        var decoded = jsonDecode(response);
        if (decoded["status"]) {
          if (i + 1 == upload.trackCount) {
            snackBar.add('$i track uploaded');

            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return new UploadPayment(
                  id: release.albumId, count: upload.trackCount, type: 'album', isDrawer: true);
            }));
          }
        } else if (decoded["error"] != null) {
          snackBar.add(decoded["error"][0] ?? 'You have invalid field');
          return;
        } else {
          snackBar.add('Something went wrong, please try again later.');
          return;
        }
      }
    }
  }
  // uploadSongs(Music upload) async {
  //   _showProgress.add(true);
  //   final _random = new Random();

  //   String fileName =
  //       '${DateTime.now().millisecondsSinceEpoch}${100 + _random.nextInt(999 - 100)}${path.extension(upload.song)}';
  //   FormData datas = new FormData.from({
  //     "label": upload.releaseName,
  //     "title": upload.title,
  //     "description": upload.description,
  //     "genre": upload.genre,
  //     "stream": upload.stream,
  //     "state": upload.vibe_state,
  //     "push_state": upload.push_state,
  //     "push_city": upload.push_city,
  //     "release_date": upload.release_date,
  //     "song": new UploadFileInfo(new File(upload.song), fileName),
  //     "image": upload.image
  //   });

  //   String response = await network
  //       .postWithFile(UiData.domain + "/songs/upload", body: datas);
  //   print('What is got is $response');
  //   var decoded = jsonDecode(response);

  //   if (decoded is List) {
  //     if (decoded[0]["field"] != null) {
  //       snackBar.add('decoded[0]["message"]');
  //       _showProgress.add(false);
  //       return;
  //     }
  //   } else {
  //     if (decoded["status"] != null) {
  //       if (decoded["status"] == 401) {
  //         snackBar.add('Your login session has expired.');
  //       } else if (decoded["status"]) {
  //         //snackBar.add('${decoded["body"]["title"]} successfully uploaded');
  //         snackBar.add('Successfully uploaded');
  //       }
  //     } else if (decoded["error"] != null) {
  //       print('Entered error else');
  //       print(decoded["error"][0]);
  //       snackBar.add(decoded["error"][0] ?? 'You have invalid field');
  //     } else {
  //       snackBar.add('Something went wrong, please try again later.');
  //     }
  //     return;
  //   }
  // }

  dispose() {
    _uploadSingles.close();
    _showProgress.close();
    snackBar.close();
  }
}

final uploadBloc = UploadBloc();

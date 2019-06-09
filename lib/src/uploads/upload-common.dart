import 'package:flutter/material.dart';
import 'package:vsartist/src/uploads/album-upload.dart';
import 'package:vsartist/src/uploads/singles-upload.dart';

class UploadCommon {
  singleUploadPage(context, pages, page, releaseName, tracksModel) {
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SinglesUpload(
          pages: pages,
          releaseName: releaseName,
          uploadSingles: tracksModel,
          page: page);
    }));
  }
  albumTrackUploadPage(context, pages, page, releaseName, tracksModel) {
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new AlbumUpload(
          pages: pages,
          releaseName: releaseName,
         uploadAlbum : tracksModel,
          page: page);
    }));
  }
}

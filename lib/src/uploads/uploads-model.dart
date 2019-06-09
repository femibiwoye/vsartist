import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

///These are models for album upload
class UploadAlbum {
  String title;
  String description;
  String image;
  String year;
  int trackCount;
  DateTime releaseDate;
  List<Music> tracks;

  factory UploadAlbum.fromJson(Map<String, dynamic> json) {
    return UploadAlbum(
      title: json['title'],
      description: json['description'],
      year: json['year'],
      trackCount: json['trackCount'],
      releaseDate: json['releaseDate'],
      image: json['image'],
      tracks: (json['tracks'] as List).map((i) => Music.fromJson(i)).toList(),
    );
  }
  Music tojson = Music();

  Map<String, dynamic> toJson(UploadAlbum instance) => <String, dynamic>{
        'title': instance.title,
        'description': instance.description,
        'year': instance.year,
        'track_count': instance.trackCount,
        'release_date': instance.releaseDate,
        'year': instance.releaseDate.year.toString(),
        'image': instance.image,
        'tracks': instance.tracks.map((i) => tojson.toJson(i)).toList()
      };

  UploadAlbum(
      {this.title,
      this.description,
      this.image,
      this.year,
      this.trackCount,
      this.releaseDate,
      this.tracks});
}

class UploadAlbumDetails {
  int albumId;
  String title;
  String description;
  String image;
  String year;
  int amountExpected;
  String trackCount;

  String releaseDate;

  factory UploadAlbumDetails.fromJson(Map<String, dynamic> json) {
    return UploadAlbumDetails(
        albumId: json['id'] != null
            ? json['id'] is int ? json['id'] : int.tryParse(json['id'])
            : 0,
        title: json['title'],
        description: json['description'],
        year: json['year'] != null ? json['year'] : '',
        trackCount: json['track_count'].toString(),
        releaseDate: json['release_date'].toString(),
        amountExpected:
            json['amount_expected'] != null ? json['amount_expected'] : 0,
        image: json['image']);
  }

  Music tojson = Music();

  Map<String, dynamic> toJson(UploadAlbumDetails instance) => <String, dynamic>{
        'title': instance.title,
        'description': instance.description,
        'release_date': instance.releaseDate.toString(),
        // 'year': instance.releaseDate.year.toString(),
        'track_count': instance.trackCount,
        'image': instance.image
      };

  UploadAlbumDetails(
      {this.albumId,
      this.title,
      this.description,
      this.image,
      this.year,
      this.trackCount,
      this.amountExpected,
      this.releaseDate});
}

/// Singles relase upload
class UploadSingles {
  int tracksNumber;
  String releaseName;
  DateTime releaseDate;
  List<Music> tracks;

  factory UploadSingles.fromJson(Map<String, dynamic> json) {
    return UploadSingles(
      tracksNumber: json['tracksNumber'],
      releaseName: json['releaseName'],
      releaseDate: json['releaseDate'],
      tracks: (json['tracks'] as List).map((i) => Music.fromJson(i)).toList(),
    );
  }

  Music tojson = Music();

  Map<String, dynamic> toJson(UploadSingles instance) => <String, dynamic>{
        'track_count': instance.tracksNumber,
        'release_name': instance.releaseName,
        'release_date': instance.releaseDate,
        'tracks': instance.tracks.map((i) => tojson.toJson(i)).toList()
      };

  UploadSingles(
      {this.tracksNumber, this.releaseName, this.releaseDate, this.tracks});
}

class ReleaseSingle {
  int releaseId;
  int amountExpected;
  String tracksNumber;
  String releaseName;
  String releaseDate;

  ReleaseSingle({
    this.releaseId,
    this.amountExpected,
    this.tracksNumber,
    this.releaseName,
    this.releaseDate,
  });

  Map<String, dynamic> toJson(ReleaseSingle instance) {
    return {
      'track_count': instance.tracksNumber.toString(),
      'release_name': instance.releaseName,
      'release_date': instance.releaseDate
    };
  }

  factory ReleaseSingle.fromJson(Map<String, dynamic> json) {
    return new ReleaseSingle(
      releaseId: json['id'],
      amountExpected: json['amount_expected'] is int
          ? json['amount_expected']
          : int.tryParse(json['amount_expected']),
      tracksNumber: json['track_count'].toString(),
      releaseName: json['release_name'],
      releaseDate: json['release_date'].toString(),
    );
  }
}

/// These are fields for each tracks
class Music {
  String releaseId;
  String albumId;
  String releaseName;
  String duration;
  String title;
  String description;
  String genre;
  String country = 'Nigeria';
  String vibe_state;
  String push_state;
  String push_city;
  String stream;
  String streamed;
  String release_date;
  String image;
  String song;
  String verificationStatus;

  Music(
      {this.releaseId,
      this.albumId,
      this.releaseName,
      this.duration,
      this.title,
      this.description,
      this.genre,
      this.country,
      this.vibe_state,
      this.push_city,
      this.push_state,
      this.stream,
      this.streamed,
      this.release_date,
      this.image,
      this.song,
      this.verificationStatus});

  Map<String, dynamic> toJson(Music instance) {
    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}${path.extension(instance.song)}';
    return {
      'release_id': instance.releaseId,
      'album_id': instance.albumId,
      'title': instance.title,
      'duration': instance.duration,
      'release_name': instance.releaseName,
      'description': instance.description,
      'genre': instance.genre,
      'country': instance.country,
      'state': instance.vibe_state,
      'push_city': instance.push_city,
      'push_state': instance.push_state,
      'stream': instance.stream,
      'release_date': instance.release_date,
      'image': instance.image,
      'song': new UploadFileInfo(new File(instance.song), fileName),
    };
  }

  factory Music.fromJson(Map<String, dynamic> json) {
    return new Music(
        releaseId: json['release_id'].toString(),
        albumId: json['album_id'].toString(),
        title: json['title'],
        releaseName: json['release_name'],
        description: json['description'],
        genre: json['genre'],
        country: json['country'],
        vibe_state: json['state'],
        push_city: json['push_city'],
        push_state: json['push_state'],
        stream: json['stream'].toString(),
        streamed: json['streamed'].toString(),
        release_date: json['release_date'],
        image: json['image'],
        song: json['song'],
        verificationStatus: json['verification_status'].toString());
  }
}

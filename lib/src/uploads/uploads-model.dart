import 'dart:io';

class UploadSingles {
  int tracksNumber;
  String releaseName;
  DateTime releaseDate;
  List<Music> tracks;
  

  factory UploadSingles.fromJson(Map<String, dynamic> json) {
    return UploadSingles(
      tracksNumber: json['tracks'],
      releaseName: json['releaseName'],
      releaseDate: json['releaseDate'],
      tracks: (json['tracks'] as List).map((i) => Music.fromJson(i)).toList(),
    );
  }
  UploadSingles(
      {this.tracksNumber, this.releaseName, this.releaseDate, this.tracks});
}

class Music {
  String releaseName;
  String title;
  String description;
  String genre;
  String country = 'Nigeria';
  String vibe_state;
  String push_state;
  String push_city;
  String stream;
  String release_date;
  String image;
  String song;

  Music(
      {this.releaseName,
      this.title,
      this.description,
      this.genre,
      this.country,
      this.vibe_state,
      this.push_city,
      this.push_state,
      this.stream,
      this.release_date,
      this.image,
      this.song});

  Map<String, dynamic> toJson(Music instance) => <String, dynamic>{
        'title': instance.title,
        'releaseName': instance.releaseName,
        'description': instance.description,
        'genre': instance.genre,
        'country': instance.country,
        'vibe_state': instance.vibe_state,
        'push_city': instance.push_city,
        'push_state': instance.push_state,
        'stream': instance.stream,
        'release_date': instance.release_date,
        'song': instance.song,
      };

  factory Music.fromJson(Map<String, dynamic> json) {
    return new Music(
        title: json['title'],
        releaseName: json['release_name'],
        description: json['description'],
        genre: json['genre'],
        country: json['country'],
        vibe_state: json['vibe_state'],
        push_city: json['push_city'],
        push_state: json['push_state'],
        stream: json['stream'],
        release_date: json['release_date'],
        image: json['image'],
        song: json['song']);
  }
}

import 'package:audiotags/audiotags.dart';

class Song {
  SongMetadata metadata;
  String path;

  Song(this.metadata, this.path);
}

class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  int? year;
  Picture? picture;

  SongMetadata(
    this.title,
    this.trackArtist,
    this.album,
    this.year,
    this.picture,
  );
}
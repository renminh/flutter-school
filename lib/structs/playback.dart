import 'song.dart';

class Playback {
  final List<Song> songs;
  int songIndex;
  bool playing;
  bool shuffle;

  Playback({
    required this.songs, 
    this.songIndex = 0,
    this.playing = false,
    this.shuffle = false 
  });
}
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/song_repository.dart';
import '../services/audio_service.dart';
import '../structs/playback.dart';
import '../structs/song.dart';

class SongCover extends StatelessWidget {
  final Song? song;
  final double size;

  const SongCover({super.key, this.song, this.size = 100});

  @override
  Widget build(BuildContext context) {
    if (song == null || song?.metadata == null || song?.metadata.picture == null) {
      return Icon(Icons.music_note, size: size);
    }

    return Image.memory(
      song!.metadata.picture!.bytes,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});
  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayerPage> {
  final AudioPlayer player = AudioPlayer();
  final Playback playback = Playback(songs: []);

  // wrappers cause i can't be bothered to learn value notifiers
  Future<void> playSong(int index) async
  {
    await playerPlay(player, playback, index);
    setState(() {});
  }

  Future<void> togglePlayPause() async 
  {
    await playerTogglePlayPause(player, playback);
    setState(() {});
  }
  Future<void> nextSong() async 
  {
    await playerNext(player, playback);
    setState(() {});
  }

  Future<void> previousSong() async 
  {
    await playerPrevious(player, playback);
    setState(() {});
  }

  Future<void> shuffleSong() async 
  {
    await playerShuffle(player, playback);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  // necessary bcos init state doesn't wait for my functions to finish
  Future<void> _init() async {
    await playerInitialize(player, playback, SongRepository.songPaths);
    setState(() {}); // rebuild ui when it's ready
  }

  @override
  void dispose() {
    playerDestroy(player);
    super.dispose();
  }

  // there has to be a better way rather than setting defaults and making four
  // seperate text objects to accomodate these
  Widget getDetails() {
    if (playback.songs.isEmpty) {
      return const Text(
        "Loading...",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      );
    }

    SongMetadata metadata = playback.songs[playback.songIndex].metadata; 
      // set defaults
      String title =  (metadata.title == null) ? "Unknown" : metadata.title!;
      String artist = (metadata.trackArtist == null) ? "Unknown" : metadata.trackArtist!;
      String album = (metadata.album == null) ? "Unknown" : metadata.album!;
      String year = (metadata.year == null) ? "Unknown" : metadata.year!.toString();
      return Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700) 
          ),
          Text(
            artist,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400) 
          ),
          Text(
            "$album • $year",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            )
          )
        ]
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music Player")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // https://api.flutter.dev/flutter/widgets/Image/Image.memory.html
            SongCover(song: playerGetCurrentSong(playback), size: 400.0),
            getDetails(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => SongListPage(
                          songs: playback.songs,
                          onSongSelected: playSong
                        ),
                      )
                    );
                  }, 
                  icon: Icon(Icons.library_music),
                  iconSize: 40,
                ),
                // can't use it cos return is void so it can't be checked huhh?
                IconButton(icon: Icon(Icons.skip_previous), iconSize: 25, onPressed: previousSong),
                IconButton(
                  icon: Icon(playback.playing ? Icons.pause_circle : Icons.play_circle), 
                  iconSize: 25, 
                  onPressed: togglePlayPause
                ),
                IconButton(icon: Icon(Icons.skip_next), iconSize: 25, onPressed: nextSong),
                IconButton(icon: Icon(Icons.shuffle), iconSize: 25, onPressed: shuffleSong),
              ],
            )
          ],
        )
      ),
    );
  }
}
class SongListPage extends StatelessWidget {
  final List<Song> songs;
  final Function(int) onSongSelected;

  const SongListPage({super.key, 
    required this.songs,
    required this.onSongSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          SongMetadata metadata = songs[index].metadata;
          String? title = metadata.title;
          String? artist = metadata.trackArtist;

          return ListTile(
            leading: SongCover(song: songs[index], size: 40.0),
            title: Text(
              "$title\n$artist"),
            onTap: () {
              onSongSelected(index);
              Navigator.pop(context);
            } ,
          );
        }
      )
    );
  }
}
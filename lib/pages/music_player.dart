import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'dart:math';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  _MusicPlayerState createState() =>_MusicPlayerState();
}

class Song {
  SongMetadata metadata;
  String path;

  Song(
    this.metadata,
    this.path,
  );
}

// perfect time to have a struct for the meta data
// prolly be better to wrap the data of the song player as well
// https://medium.com/@suatozkaya/dart-constructors-101-69c5b9db5230
class SongMetadata {
  String? title;
  String? trackArtist;
  String? album;
  int? year;
  Picture? picture;

  // https://dart.dev/language/constructors#generative-constructors
  // creating a constructor for the "struct"
  SongMetadata(
    this.title,
    this.trackArtist,
    this.album,
    this.year,
    this.picture,
  );
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<Song> songs;

  int currentIndex = 0;
  bool _isPlaying = false;

  final List<String> _songPaths = [
    'assets/music/Algo contigo.mp3',
    'assets/music/Eu desespero.mp3',
    'assets/music/Eu seu que vou te amar.mp3',
    'assets/music/Senhorinha.mp3',
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    songs = [];

    _initPlayer();  
  }

  Future<void> _initPlayer() async {
    await _getSongs(_songPaths);

    // preload the first song to avoid ui lagging behind
    // grabbing the songs to audioplayer and audiotags
    if (songs.isNotEmpty) {
      await _audioPlayer.setSource(
        AssetSource(songs[0].path),
      );

      setState(() {
        currentIndex = 0;
      });
    }
  }

  Future<void> _getSongs(List<String> songPaths) async {
    for (int i = 0; i < songPaths.length; i++) {
      Tag? tag = await AudioTags.read(songPaths[i]);
      SongMetadata metadata = SongMetadata(null, null, null, null, null);

      metadata.title = tag?.title;
      metadata.trackArtist = tag?.trackArtist;
      metadata.album = tag?.album;
      metadata.year = tag?.year;
      List<Picture>? pictures = tag?.pictures;
      metadata.picture = pictures?[0];

      Song song = Song(
        metadata,
        songPaths[i].replaceFirst("assets/", ""),
      );
      songs.add(song);
    }
  }

  Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(songs[index].path));
    setState(() {
      currentIndex = index;
      _isPlaying = true;
    });
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextSong() {
    currentIndex = (currentIndex + 1) % songs.length;
    setState(() {
      _playSong(currentIndex);
    });
  }

  void _prevSong() {
    currentIndex = (currentIndex - 1) % songs.length;
    setState(() {
      _playSong(currentIndex);
    });
  }

  void _shuffleSong() {
    /* inclusive <= int < exclusive */
    currentIndex = Random().nextInt(songs.length);
    setState(() {
      _playSong(currentIndex);
    });
  }

  @override
  /* Called when this object is removed from the tree permanently.

  The framework calls this method when this [State] object will never build again. 
  After the framework calls [dispose], 
  the [State] object is considered unmounted and the [mounted] property is false. 
  It is an error to call [setState] at this point. This stage of the lifecycle is terminal: 
  there is no way to remount a [State] object that has been disposed.
  Subclasses should override this method to release any resources retained 
  by this object (e.g., stop any active animations).
  */
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  Widget getImage() {
  if (songs.isEmpty) {
     return Icon(Icons.music_note, size: 100,);
  }

  SongMetadata metadata = songs[currentIndex].metadata; 

    if (metadata.picture == null) {
      return Icon(Icons.music_note, size: 100,);
    }

    return Image.memory(
      metadata.picture!.bytes,
      width: 500,
      height: 500,
      fit: BoxFit.cover
    );
  }

  // there has to be a better way rather than setting defaults and making four
  // seperate text objects to accomodate these
  Widget getDetails() {
    if (songs.isEmpty) {
    return const Text(
      "Loading...",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    );
  }

  SongMetadata metadata = songs[currentIndex].metadata; 
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
      appBar: AppBar(
        title: Text("Music Player"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // https://api.flutter.dev/flutter/widgets/Image/Image.memory.html
            getImage(),
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
                          songs: songs,
                          onSongSelected: _playSong
                        ),
                      )
                    );
                  }, 
                  icon: Icon(Icons.library_music),
                  iconSize: 40,
                ),

                IconButton(icon: Icon(Icons.skip_previous), iconSize: 25, onPressed: _prevSong),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle), 
                  iconSize: 25, 
                  onPressed: () {
                    _togglePlayPause();
                  } 
                ),
                IconButton(icon: Icon(Icons.skip_next), iconSize: 25, onPressed: _nextSong),
                IconButton(icon: Icon(Icons.shuffle), iconSize: 25, onPressed: _shuffleSong),

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
          String? songName = songs[index].metadata.title;

          return ListTile(
            title: Text(
              songName!),
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
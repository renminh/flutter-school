import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'dart:math';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  _MusicPlayerState createState() =>_MusicPlayerState();
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
  SongMetadata songMetadata = SongMetadata(null, null, null, null, null);

  int currentIndex = 0;
  bool _isPlaying = false;
  
  final List<String> _songs = [
    'assets/music/Algo contigo.mp3',
    'assets/music/Eu desespero.mp3',
    'assets/music/Eu seu que vou te amar.mp3',
    'assets/music/Senhorinha.mp3',
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    
    // having some issues with not being able to play the song
    // even though the UI shows the metadata loaded
    // this has to do with async which and initState, which means
    // i need to preload it along with getting the metadata on first
    // open of the page
    _preload();
    
  }

  Future<void> _preload() async {
    // metadata for ui
    await _getMetadata(currentIndex);

    // preload to the audioplayer
    await _audioPlayer.setSource(
      AssetSource(_songs[currentIndex].replaceFirst("assets/", "")),
    );
  }
  Future<void> _getMetadata(int index) async {
    Tag? tag = await AudioTags.read(_songs[index]);

    setState(() {
      songMetadata.title = tag?.title;
      songMetadata.trackArtist = tag?.trackArtist;
      songMetadata.album = tag?.album;
      songMetadata.year = tag?.year;
      List<Picture>? pictures = tag?.pictures;
      songMetadata.picture = pictures?[0];
    });
  }

  Future<void> _playSong(int index) async {
    await _getMetadata(index);
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(_songs[index].replaceFirst("assets/", "")));
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
    currentIndex = (currentIndex + 1) % _songs.length;
    setState(() {
      _playSong(currentIndex);
    });
  }

  void _prevSong() {
    currentIndex = (currentIndex - 1) % _songs.length;
    setState(() {
      _playSong(currentIndex);
    });
  }

  void _shuffleSong() {
    /* inclusive <= int < exclusive */
    currentIndex = Random().nextInt(_songs.length);
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
    if (songMetadata.picture == null) {
      return Icon(Icons.music_note, size: 100,);
    }

    return Image.memory(
      songMetadata.picture!.bytes,
      width: 500,
      height: 500,
      fit: BoxFit.cover
    );
  }

  // there has to be a better way rather than setting defaults and making four
  // seperate text objects to accomodate these
  Widget getDetails() {

    // set defaults
    String title =  (songMetadata.title == null) ? "Unknown" : songMetadata.title!;
    String artist = (songMetadata.trackArtist == null) ? "Unknown" : songMetadata.trackArtist!;
    String album = (songMetadata.album == null) ? "Unknown" : songMetadata.album!;
    String year = (songMetadata.year == null) ? "Unknown" : songMetadata.year!.toString();
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
                          songs: _songs,
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
  final List<String> songs;
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
          String songName = songs[index].split("/").last;

          return ListTile(
            title: Text(songName),
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
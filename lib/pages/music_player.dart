import 'dart:collection';
import 'dart:io'; /* https://api.dart.dev/dart-io/Directory-class.html */

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class MusicPlayerPage extends StatefulWidget {
  MusicPlayerPage({super.key});

  @override
  _MusicPlayerState createState() =>_MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentIndex = 0;
  bool _isPlaying = false;

  final List<String> _songs = [
    'assets/music/Alfonsina y el mar.mp3',
    'assets/music/Algo contigo.mp3',
    'assets/music/Carinhoso.mp3',
    'assets/music/Eu desespero.mp3',
    'assets/music/Eu seu que vou te amar [diJUYlUFElM].mp3',
    'assets/music/If the Moon Turns Green.mp3',
    'assets/music/Imagina.mp3',
    'assets/music/Oración del remanso.mp3',
    'assets/music/Porque llorax blanca niña.mp3',
    'assets/music/Quien lo diria.mp3'
  ];

  Future<void> _playSong(int index) async {
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

  void _dispose() {
    /* what is this function again */
    setState(() {
      _audioPlayer.stop();
    });
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
            Icon(Icons.music_note, size: 100,),
            SizedBox(
              height: 40,
              child: Text(_songs[currentIndex].split("/").last),),
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
                  icon: Icon(Icons.play_circle), 
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

  SongListPage({
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
            onTap: () => onSongSelected(index),
          );
        }
      )
    );
  }
}


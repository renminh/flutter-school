import 'package:flutter/material.dart';
import 'types.dart';
import 'widgets/mp3_cover.dart';

class TrackPage extends StatelessWidget {
  final List<Song> songs;
  final void Function(int) onTap;

  const TrackPage({super.key, 
    required this.songs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return TrackItem(song: songs[index], onTap: onTap, index: index);
        }
      )
    );
  }
}

class TrackItem extends StatelessWidget {
  final Song song;
  final int index;
  final Function(int) onTap;

  const TrackItem({
    super.key,
    required this.index,
    required this.song,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    SongMetadata metadata = song.metadata;
    String? title = metadata.title;
    String? artist = metadata.trackArtist;

    return ListTile(
      leading: Mp3Cover(song: song, size: 40.0),
      title: Text(
        "$title\n$artist"),
      onTap: () {
        onTap(index);
        Navigator.pop(context);
      } ,
    );
  }
}

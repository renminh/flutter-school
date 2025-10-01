import 'package:app_lab/mp3/types.dart';
import 'package:flutter/material.dart';
import '../track_page.dart';

// https://stackoverflow.com/a/53312484
// callbacks can be used almost as function pointers to attach them to the widget
class PlaybackControl extends StatelessWidget {
	final void Function(int) playSong;
	final VoidCallback nextSong;
	final VoidCallback previousSong;
	final VoidCallback togglePlayPause;
	final VoidCallback shuffleSong;
	final Playback playback;

	const PlaybackControl ({
		super.key,
		required this.playSong,
		required this.nextSong,
		required this.previousSong,
		required this.togglePlayPause,
		required this.shuffleSong,
		required this.playback
	});

	@override
	Widget build(BuildContext context) {
		return Row(
		mainAxisAlignment: MainAxisAlignment.center,
		crossAxisAlignment: CrossAxisAlignment.center,
		children: [
			IconButton(
				onPressed: () {
					Navigator.push(
						context,
						MaterialPageRoute<void>(
							builder: (context) => TrackPage(
							songs: playback.songs,
							onTap: playSong
							),
						)
					);
				},
				icon: Icon(Icons.library_music),
				iconSize: 40,
			),
			IconButton(icon: Icon(Icons.skip_previous), iconSize: 25, onPressed: previousSong),
			IconButton(
				icon: Icon(playback.playing ? Icons.pause_circle : Icons.play_circle),
				iconSize: 25,
				onPressed: togglePlayPause
			),
			IconButton(icon: Icon(Icons.skip_next), iconSize: 25, onPressed: nextSong),
			IconButton(icon: Icon(Icons.shuffle), iconSize: 25, onPressed: shuffleSong),
		],
		);
	}
}

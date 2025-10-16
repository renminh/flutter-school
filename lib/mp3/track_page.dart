import 'package:app_lab/mp3/player.dart';
import 'package:flutter/material.dart';
import 'song.dart';
import 'widgets/cover.dart';

class TrackPage extends StatelessWidget {
	final Mp3Player player;
	final void Function(int) on_tap;

	const TrackPage({
		super.key,
		required this.player,
		required this.on_tap
	});

	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: Text("Select a song")),
			body: ListView.builder(
				itemCount: player.tracks.length,
				itemBuilder: (context, index) {
					return TrackItem(
						track: player.tracks[index],
						on_tap: on_tap,
						index: index
					);
				}
			)
		);
	}
}

class TrackItem extends StatelessWidget {
	final Track track;
	final int index;
	final Function(int) on_tap;

	const TrackItem({
		super.key,
		required this.index,
		required this.track,
		required this.on_tap
	});

	@override
  	Widget build(BuildContext context)
  	{
		return InkWell(
			onTap: () {
				on_tap(index);
				Navigator.pop(context);
			},
			child: Row(
				children: [
					TrackCover(track: track, size: 100),
					SizedBox(width: 10),
					Column(
						mainAxisAlignment: MainAxisAlignment.start,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(track.title),
							Text(
								track.artist,
								style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))
							)
						]
					)
				],
			),
		);
  	}
}

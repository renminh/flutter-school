import 'package:flutter/material.dart';
import '../song.dart';


class TrackCover extends StatelessWidget {
	final Track track;
	final double size;

	const TrackCover({super.key, required this.track, this.size = 100});

	@override
	Widget build(BuildContext context)
	{
		return SizedBox(
			width: size,
			height: size,
			child: track_cover_build(track)
		);
	}
}

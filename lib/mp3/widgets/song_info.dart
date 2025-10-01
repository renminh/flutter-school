import 'package:flutter/material.dart';
import '../types.dart';

class SongInfo extends StatelessWidget {
	final Song? song;

	const SongInfo({
		super.key,
		this.song
	});

	@override
	Widget build(BuildContext context) {
		if (song == null) {
			return const Text(
				"Loading...",
				style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
			);
		}
		SongMetadata metadata = song!.metadata;

		return Column(
			children: [
				Text(
					metadata.title!,
					style: TextStyle(
						fontSize: 26,
						fontWeight: FontWeight.w700)
				),
				Text(
					metadata.trackArtist!,
					style: TextStyle(
						fontSize: 20,
						fontWeight: FontWeight.w300)
				),
				Text(
					"${metadata.album!} • ${metadata.year.toString()}",
					style: TextStyle(
						fontSize: 16,
						fontWeight: FontWeight.w300,
					)
				)
			]
		);
	}
}

import 'package:flutter/material.dart';
import '../../core/song.dart';

class SongInfo extends StatelessWidget {
	final Song? song;

	const SongInfo({super.key, this.song});

	@override
	Widget build(BuildContext context) {
		if (song == null) {
			return const Text(
				"Loading...",
				style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
			);
		}
		SongMetadata metadata = song!.metadata;

		final screenWidth = MediaQuery.of(context).size.width;
		double scale = 1.0;
		if (screenWidth > 1000) {
			scale = 1.3;
		}
		if (screenWidth < 400) {
			scale = 0.8;
		}
		if (screenWidth < 200) {
			scale = 0.5;
		}

		return Column(
			children: [
				Text(
					metadata.title!,
					style: TextStyle(
						fontSize: 26 * scale,
						fontWeight: FontWeight.w700)
				),
				Text(
					metadata.trackArtist!,
					style: TextStyle(
						fontSize: 20 * scale,
						fontWeight: FontWeight.w300)
				),
				Text(
					"${metadata.album!} • ${metadata.year.toString()}",
					style: TextStyle(
						fontSize: 16 * scale,
						fontWeight: FontWeight.w300,
					)
				)
			]
		);
	}
}

import 'package:flutter/material.dart';
import '../types.dart';


class Mp3Cover extends StatelessWidget {
	final Song? song;
	final double size;

	const Mp3Cover({super.key, this.song, this.size = 100});

	@override
	Widget build(BuildContext context)
	{
		if (song == null || song?.metadata == null || song?.metadata.picture == null) {
			return Icon(Icons.music_note, size: size);
		}

		return ClipRRect(
			borderRadius: BorderRadius.circular(8),
			child: Image.memory(
				song!.metadata.picture!.bytes,
				width: size,
				height: size,
				fit: BoxFit.cover,
			),
		);
	}
}

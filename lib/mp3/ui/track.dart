import 'package:flutter/material.dart';
import '../core/song.dart';
import 'widgets/cover.dart';

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
    return InkWell(
      onTap: () {
        onTap(index);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Square cover art
            SizedBox(
              width: 80,
              height: 80,
              child: SongCover(song: song, size: 80),
            ),
            const SizedBox(width: 16),
            // Flexible track info
            Expanded(
              child: TrackInfo(metadata: song.metadata),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackInfo extends StatelessWidget {
	final SongMetadata metadata;

	const TrackInfo({super.key, required this.metadata});

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Text(metadata.title!, maxLines: 1, overflow: TextOverflow.ellipsis,
					style: TextStyle(
						fontWeight: FontWeight.w700,
						fontSize: 16
					)
				),

				Text(metadata.trackArtist!, maxLines: 1, overflow: TextOverflow.ellipsis,
					style: TextStyle(
						color: Color.fromARGB(255, 129, 129, 129),
						fontWeight: FontWeight.w300,
						fontSize: 12
					)
				),

				if (metadata.album != null)
					Text(
						"${metadata.album!} • ${metadata.year}",
						style: TextStyle(
							color: Color.fromARGB(255, 129, 129, 129),
							fontWeight: FontWeight.w300,
							fontSize: 12
					)
				),
			],
		);
	}
}

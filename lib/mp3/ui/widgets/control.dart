import 'package:app_lab/mp3/core/player.dart';
import 'package:flutter/material.dart';
import '../track.dart';

class PlaybackControl extends StatelessWidget {
	final void Function(int) playSong;
	final VoidCallback nextSong;
	final VoidCallback previousSong;
	final VoidCallback togglePlayPause;
	final VoidCallback shuffleSong;
	final Playback playback;
	final double volume;
	final ValueChanged<double> onVolumeChanged;

	const PlaybackControl({
		super.key,
		required this.playSong,
		required this.nextSong,
		required this.previousSong,
		required this.togglePlayPause,
		required this.shuffleSong,
		required this.playback,
		required this.volume,
		required this.onVolumeChanged,
	});

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) {
				final screenWidth = MediaQuery.of(context).size.width;

				double iconSize;
				double spacing;
				double sliderWidth;
				iconSize = 36;
				spacing = 30;
				sliderWidth = 400;

				if (screenWidth < 800) {
					iconSize = 28;
					spacing = 20;
					sliderWidth = 280;
				}

				if (screenWidth < 400) {
					iconSize = 20;
					spacing = 12;
					sliderWidth = 200;
				}

				if (screenWidth < 220) {
					iconSize = 18;
					spacing = 10;
					sliderWidth = 160;
				}

				ColorFilter whiteIcon = const ColorFilter.mode(Colors.white, BlendMode.srcIn);

				Widget buildIcon(String path) => ColorFiltered(
					colorFilter: whiteIcon,
					child: Image.asset(
						path,
						width: iconSize,
						height: iconSize,
					),
					);

				return Column(
				children: [
					const SizedBox(height: 3),
					Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							IconButton(
							icon: buildIcon('assets/icon/folder-music.png'),
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute<void>(
										builder: (context) => TrackPage(
										songs: playback.songs,
										onTap: playSong,
										),
									),
								);
							},
							iconSize: iconSize,
							),

							SizedBox(width: spacing),
							IconButton(
								icon: buildIcon('assets/icon/rewind.png'),
								onPressed: previousSong,
								iconSize: iconSize,
							),

							IconButton(
								icon: buildIcon(playback.playing
									? 'assets/icon/pause.png'
									: 'assets/icon/play.png'),
								onPressed: togglePlayPause,
								iconSize: iconSize * 1.2,
							),

							// Forward
							IconButton(
								icon: buildIcon('assets/icon/forward.png'),
								onPressed: nextSong,
								iconSize: iconSize,
							),

							SizedBox(width: spacing),

							// Shuffle
							IconButton(
								icon: buildIcon('assets/icon/shuffle.png'),
								onPressed: shuffleSong,
								iconSize: iconSize,
							),
						],
					),

					const SizedBox(height: 2),

					// Volume slider
					SizedBox(
						width: sliderWidth,
						child: Slider(
							value: volume,
							min: 0,
							max: 1,
							onChanged: onVolumeChanged,
							activeColor: Colors.white,
							inactiveColor: Colors.grey,
						),
					),
				],
				);
			},
		);
	}
}

import 'dart:async';

import 'package:app_lab/config.dart';
import 'package:app_lab/util/util.dart';
import 'package:flutter/material.dart';
import '../player.dart';
import '../track_page.dart';

const AssetImage ICN_PLAY = AssetImage("assets/icon/play.png");
const AssetImage ICN_PAUSE = AssetImage("assets/icon/pause.png");
const AssetImage ICN_FF = AssetImage("assets/icon/forward.png");
const AssetImage ICN_REWIND = AssetImage("assets/icon/rewind.png");
const AssetImage ICN_LIB = AssetImage("assets/icon/folder-music.png");
const AssetImage ICN_SHUFFLE = AssetImage("assets/icon/shuffle.png");
const AssetImage ICN_NO_SHUFFLE = AssetImage("assets/icon/shuffle-off.png");
const AssetImage ICN_VOL_UP = AssetImage("assets/icon/volume.png");
const AssetImage ICN_VOL_DOWN = AssetImage("assets/icon/volume-down.png");
const AssetImage ICN_VOL_MUTE = AssetImage("assets/icon/volume-mute.png");

Widget icon_build(AssetImage image, double size)
{
	return pipe_icon(
		Image(
			image: image,
			width: size,
			height: size,
		)
	);
}

// https://stackoverflow.com/a/75045907
Widget pipe_icon(Image image)
{
	return ColorFiltered(
		colorFilter: DARK_MODE
			? const ColorFilter.matrix(<double>[
				-1.0, 0.0, 0.0, 0.0, 255.0, //
				0.0, -1.0, 0.0, 0.0, 255.0, //
				0.0, 0.0, -1.0, 0.0, 255.0, //
				0.0, 0.0, 0.0, 1.0, 0.0, //
			])
			: const ColorFilter.matrix(<double>[
				1.0, 0.0, 0.0, 0.0, 0.0, //
				0.0, 1.0, 0.0, 0.0, 0.0, //
				0.0, 0.0, 1.0, 0.0, 0.0, //
				0.0, 0.0, 0.0, 1.0, 0.0, //
			]),
		child: image,
	);
}

class PlayerControls extends StatefulWidget {
	final Mp3Player player;
	final VoidCallback parent_update;

	const PlayerControls({
		super.key,
		required this.player,
		required this.parent_update
	});

	@override
	PlayerControlsState createState() => PlayerControlsState();
}

class PlayerControlsState extends State<PlayerControls> {
	late StreamSubscription<Duration> position_stream;
	late StreamSubscription<void> complete_stream;
	late Mp3Player player;

	@override
	void initState()
	{
		super.initState();
		player = widget.player;
		audio_stream_init(player);
	}
	
	// streams available are over at
	// https://github.com/bluefireteam/audioplayers/blob/main/getting_started.md
	void audio_stream_init(Mp3Player player)
	{
		position_stream = player.audio.onPositionChanged.listen((Duration p) {
			setState(() => player.current_position = p);
		});

		complete_stream = player.audio.onPlayerComplete.listen((_) async {
			await player_next(player);
			widget.parent_update();
		});
	}

	@override
	void dispose()
	{
		position_stream.cancel();
		complete_stream.cancel();
		super.dispose();
	}

	@override
  	Widget build(BuildContext context)
	{
		return Column(
			crossAxisAlignment: CrossAxisAlignment.center,
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: [
				build_seekbar(player),
				Row(
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						build_library_button(player, 20),
						build_rewind_button(player, 20),
						build_resume_pause_button(player, 28),
						build_ff_button(player, 20),
						build_shuffle_button(player, 20),
				]),
				build_volume_slider(player),
			],
		);
	}

	// https://dev.to/bigbott/flutter-play-audio-with-the-progress-bar-and-a-bit-more-1g5n
	Widget build_seekbar(Mp3Player player)
	{
		double slide_pos = player.current_position.inSeconds.toDouble();
		double slide_dur = player_current_track(player).duration.inSeconds.toDouble();

		return Row(
			crossAxisAlignment: CrossAxisAlignment.center,
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Text(MM_SS_FORMAT_DUR(player.current_position)),
				Slider(
					value: slide_pos,
					min: 0.0,
					max: slide_dur,
					activeColor: Colors.white,
					inactiveColor: Colors.grey,
					onChanged: (value) async {
						await player_seek_to(player, Duration(seconds: value.toInt()));
						setState(() {});
					}
				),
				Text(MM_SS_FORMAT_DUR(player_current_track(player).duration))
			]
		);
	}

	Widget build_ff_button(Mp3Player player, double size)
	{
		return IconButton(
			icon: icon_build(ICN_FF, size),
			onPressed: () async {
				await player_next(player);
				widget.parent_update();
			},
		);
	}

	Widget build_rewind_button(Mp3Player player, double size)
	{
		return IconButton(
			icon: icon_build(ICN_REWIND, size),
			onPressed: () async {
				await player_previous(player);
				widget.parent_update();
			},
		);
	}

	Widget build_library_button(Mp3Player player, double size)
	{
		return IconButton(
			icon: icon_build(ICN_LIB, size),
			onPressed: () async {
				Navigator.push(
					context,
					MaterialPageRoute(
						builder: (context) => TrackPage(
							player: player,
							on_tap: (index) async {
								await player_play(player, index);
								widget.parent_update();
							}
						)
					),
				);
			},
		);
	}

	Widget build_resume_pause_button(Mp3Player player, double size)
	{
		Widget icon = player.playing
			? icon_build(ICN_PAUSE, size)
			: icon_build(ICN_PLAY, size);

		return IconButton(
			icon: icon,
			onPressed: () async {
				await player_toggle_resume_pause(player);
				setState(() {});
			},
		);
	}

	Widget build_shuffle_button(Mp3Player player, double size)
	{
		Widget icon = player.shuffled
			? icon_build(ICN_SHUFFLE, size)
			: icon_build(ICN_NO_SHUFFLE, size);

		return IconButton(
			icon: icon,
			onPressed: () async {
				player_shuffle_toggle(player);
				setState(() {});
			},
		);
	}

	Widget build_volume_slider(Mp3Player player)
	{
		Widget vol_down_icon = player.volume == 0.0
			? icon_build(ICN_VOL_MUTE, 24)
			: icon_build(ICN_VOL_DOWN, 24);

		return 	Row(
			crossAxisAlignment: CrossAxisAlignment.center,
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				vol_down_icon,
				Slider(
					value: player.volume,
					min: 0,
					max: 1,
					activeColor: Colors.white,
					inactiveColor: Colors.grey,
					onChanged: (value) {
						player_set_volume(player, value);
						setState(() {});
					}
				),
				icon_build(ICN_VOL_UP, 24),
			]
		);
	}
}

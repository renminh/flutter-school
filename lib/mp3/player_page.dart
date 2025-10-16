import 'package:app_lab/config.dart';
import 'package:app_lab/mp3/data/tracks.dart';
import 'package:app_lab/util/util.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'player.dart';
import 'song.dart';
import 'widgets/cover.dart';
import 'widgets/controls.dart';

class PlayerPage extends StatefulWidget {
	const PlayerPage({super.key});
	@override
	PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
	Mp3Player player = Mp3Player(audio: AudioPlayer());
  	@override
  	void initState()
	{
		super.initState();
		//player_load_tracks(player, ASSET_SONGS);
		player_load_tracks(player, TRACK_DATA);
		if (MP3_PLAY_FIRST_LOAD) player_play(player, 0);
	}

	@override
	void dispose()
	{
		player_free(player);
		super.dispose();
	}


	@override
	Widget build(BuildContext context)
	{
		double screen_width = MediaQuery.sizeOf(context).width;

		return Scaffold(
			appBar: AppBar(title: const Text("Music Player")),
			body: screen_width < MOBILE_MAX_WIDTH
				? build_mobile(context)
				: build_desktop(context),
		);
  	}

	Widget build_mobile(BuildContext context)
	{
		double screen_width = MediaQuery.sizeOf(context).width;
		Track track = player_current_track(player);
		double cover_size = CLAMPD(170, 250, screen_width * 0.7);

		return Center(
			child: Container(
				height: 600,
				width: 350,
				color: const Color.fromARGB(255, 16, 16, 16),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						TrackCover(track: track, size: cover_size),
						build_track_info(track),
						PlayerControls(player: player, parent_update: () => setState(() {}),)
					]
				)
			)
		);
	}

	Widget build_desktop(BuildContext context)
	{
		double screen_width = MediaQuery.sizeOf(context).width;
		Track track = player_current_track(player);
		double cover_size = 400;

		return Center(
			child: Container(
				height: 800,
				width: 600,
				color: const Color.fromARGB(255, 16, 16, 16),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						TrackCover(track: track, size: cover_size),
						build_track_info(track),
						PlayerControls(player: player, parent_update: () => setState(() {}),)
					]
				)
			)
		);
	}

	Widget build_track_info(Track t)
	{
		return Column(
			children: [
				Text(
					t.title,
					style: TextStyle(fontSize: 20),
				),
				Text("${t.artist} • ${t.album}", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 93, 93, 93))),
			],
		);
	}

}

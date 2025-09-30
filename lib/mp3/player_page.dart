import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'player.dart';
import 'types.dart';
import 'widgets/mp3_cover.dart';
import 'widgets/mp3_details.dart';
import 'widgets/mp3_controls.dart';
import '../util/util.dart';

class PlayerPage extends StatefulWidget {
	const PlayerPage({super.key});
	@override
	Mp3State createState() => Mp3State();
}

class Mp3State extends State<PlayerPage> {
	final AudioPlayer player = AudioPlayer();
	final Playback playback = Playback(songs: []);

	// wrappers cause i can't be bothered to learn value notifiers
	Future<void> playSong(int index) async { await playerPlay(player, playback, index); setState(() {}); }
	Future<void> togglePlayPause() async { await playerTogglePlayPause(player, playback); setState(() {}); }
	Future<void> nextSong() async { await playerNext(player, playback); setState(() {}); }
	Future<void> previousSong() async { await playerPrevious(player, playback); setState(() {}); }
	Future<void> shuffleSong() async { await playerShuffle(player, playback); setState(() {}); }
	Future<void> _init() async { await playerInitialize(player, playback, SongRepository.songPaths); setState(() {}); }

	@override
	void initState()
	{
		super.initState();
		// necessary bcos init state doesn't wait for my functions to finish
		_init();
	}

	@override
	void dispose()
	{
		playerDestroy(player);
		super.dispose();
	}

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text("Music Player")),
			body: Center(
				child: Mp3Card(
					playback: playback,
					nextSong: nextSong,
					previousSong: previousSong,
					shuffleSong: shuffleSong,
					togglePlayPause: togglePlayPause,
					playSong: playSong,
				),
			),
		);
	}
}

class Mp3Card extends StatelessWidget {
	final Playback playback;
	final Future<void> Function() nextSong;
	final Future<void> Function() previousSong;
	final Future<void> Function() shuffleSong;
	final Future<void> Function() togglePlayPause;
	final Future<void> Function(int) playSong;

	const Mp3Card({
		super.key,
		required this.playback,
		required this.nextSong,
		required this.previousSong,
		required this.shuffleSong,
		required this.togglePlayPause,
		required this.playSong,
	});
	
	@override
	Widget build(BuildContext context) 
	{
		double coverMin = 300;
		double coverMax = 600;
		return Column(
			children: [
				// https://api.flutter.dev/flutter/widgets/Image/Image.memory.html
				Mp3Cover(
					song: playerGetCurrentSong(playback), 
					size: clampd(coverMin, coverMax, MediaQuery.of(context).size.width),
				),
				Mp3Details(song: playerGetCurrentSong(playback)),
				Mp3Controls(
					playback: playback, 
					nextSong: nextSong,
					previousSong: previousSong,
					shuffleSong: shuffleSong,
					togglePlayPause: togglePlayPause,
					playSong: playSong,
				),
			],
		);
	}
}

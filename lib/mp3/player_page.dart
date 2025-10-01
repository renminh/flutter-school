// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'types.dart';
import 'widgets/cover.dart';
import 'widgets/song_info.dart';
import 'widgets/control.dart';
import 'widgets/waveform.dart';
import '../util/util.dart';

import 'package:app_lab/mp3/player/api.dart';
import 'package:app_lab/mp3/waveform/api.dart';

const double _COVERSIZEMIN = 230;
const double _COVERSIZEMAX = 440;
const double _WAVEFORMHEIGHT = 120;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});
  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  	late PlayerInterface interface;

  	@override
  	void initState() {
    	super.initState();
    	interface = PlayerInterface(player: AudioPlayer(), playback: Playback(songs: []));

		playerInitialize(
			interface.player,
			interface.playback,
			SongRepository.songPaths
		).then((_) async {
			// this is such a weird thing to do
			interface.playback.duration = await interface.player.getDuration() ?? Duration.zero;

			// necessary for tracking both position and duration from audio players
			interface.player.onPositionChanged.listen((pos) {
				interface.playback.position = pos;

				final song = playerGetCurrentSong(interface.playback);
				final wf = song != null ? waveformCache[song.path] : null;

				if (wf != null && interface.playback.duration.inMilliseconds > 0) {
					final progress = pos.inMilliseconds / interface.playback.duration.inMilliseconds;
					waveformSetProgress(wf, progress);
				}

				setState(() {});
			});

			interface.player.onDurationChanged.listen((dur) {
				interface.playback.duration = dur;
				setState(() {});
			});

			unawaited(precomputeAllWaveforms(interface.playback));
			await precomputeAllGradients(interface);

			setState(() {});
		});
	}

  	Future<void> precomputeAllGradients(PlayerInterface interface) async
	{
		for (final song in interface.playback.songs) {
			await computeSongGradient(interface, song);
		}
	}

	Future<void> precomputeAllWaveforms(Playback playback) async
	{
		for (final song in playback.songs) {
			await getWaveform("assets/${song.path}");
		}
	}


  @override
  void dispose() {
    playerDestroy(interface.player);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = playerGetCurrentSong(interface.playback);

	WaveformInterface? wf;
	if (song != null) {
		wf = waveformCache["assets/${song.path}"];
	}

    double width = MediaQuery.sizeOf(context).width;
    double coverSize = DCLAMP(_COVERSIZEMIN, _COVERSIZEMAX, width * 0.4);



    return Scaffold(
      appBar: AppBar(title: const Text("Music Player")),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [interface.color1, interface.color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              	SongCover(song: song, size: coverSize),
              	SongInfo(song: song),
				if (wf != null)
				SizedBox(
					width: coverSize + 100,
					height: _WAVEFORMHEIGHT,
					child: Waveform(
						wf: wf,
						color: interface.color1,
						overrideHeight: _WAVEFORMHEIGHT,
						onSeek: (progress) {
							late Duration newPos = progressToDuration(
								interface.playback.duration.inMilliseconds as Duration,
								progress
							);
							waveformSetProgress(wf!, progress);
							interface.player.seek(newPos);
							interface.playback.position = newPos;
							setState(() {});
						},
					),
				),
              PlaybackControl(
                playback: interface.playback,
                nextSong: 			() async => await uiNextSong(interface, () => setState(() {})),
                previousSong: 		() async => await uiPrevSong(interface, () => setState(() {})),
                shuffleSong: 		() async => await uiShuffleSong(interface, () => setState(() {})),
                togglePlayPause: 	() async => await uiTogglePlayPause(interface, () => setState(() {})),
                playSong: 			(index) async => await uiPlaySong(interface, index, () => setState(() {})),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

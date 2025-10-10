// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../core/song.dart';
import 'widgets/cover.dart';
import 'widgets/song_info.dart';
import 'widgets/control.dart';
import 'widgets/waveform.dart';
import '../../util/util.dart';
import '../../util/responsive.dart';
import 'track.dart';

import 'package:app_lab/mp3/core/player.dart';
import 'package:app_lab/mp3/core/waveform.dart';

const double _COVERSIZEMIN = 30;
const double _COVERSIZEMAX = 310;
const double _WAVEFORMHEIGHT = 120;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});
  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  	late PlayerInterface interface;

	double volume = 0.35;

	// garbage collectors for listeners
	late StreamSubscription<Duration> posSub;
	late StreamSubscription<Duration> durSub;

  	@override
  	void initState()
	{
    	super.initState();
    	interface = PlayerInterface(player: AudioPlayer(), playback: Playback(songs: []));

		playerInitialize(
			interface.player,
			interface.playback,
			SongRepository.songPaths
		).then((_) async {
			await interface.player.setVolume(volume);
			// this is such a weird thing to do
			interface.playback.duration = await interface.player.getDuration() ?? Duration.zero;

			// necessary for tracking both position and duration from audio players
			posSub = interface.player.onPositionChanged.listen((pos) {
				interface.playback.position = pos;

				final Song? song = playerGetCurrentSong(interface.playback);
				final WaveformInterface? wf = (song != null)
					? waveformCache["assets/${song.path}"]
					: null;

				if (wf != null && interface.playback.duration.inMilliseconds > 0) {
					final double progress = pos.inMilliseconds / interface.playback.duration.inMilliseconds;
					waveformSetProgress(wf, progress);
				}

				if (mounted) setState(() {});
			});

			// duration tracking
			durSub = interface.player.onDurationChanged.listen((dur) {
				interface.playback.duration = dur;

				final song = playerGetCurrentSong(interface.playback);
				final wf = (song != null) ? waveformCache["assets/${song.path}"] : null;

				if (wf != null) wf.duration = dur;

				if (mounted) setState(() {});
			});
			await waveformPreloadFirstSong(interface,  () { if (mounted) setState(() {}); });

			unawaited(precomputeAllWaveforms(interface.playback));

			if (mounted) setState(() {});
		});
	}

	void onVolumeChanged(double value) {
		setState(() {
			volume = value;
		});
		interface.player.setVolume(value);
	}

	// i hate the delay
	Future<void> waveformPreloadFirstSong(PlayerInterface interface, VoidCallback refresh) async
	{
		final firstSong = playerGetCurrentSong(interface.playback);
		if (firstSong != null) {
			await(getWaveform("assets/${firstSong.path}"));
			refresh();
		}
	}


	Future<void> precomputeAllWaveforms(Playback playback) async
	{
		for (final song in playback.songs) {
			await getWaveform("assets/${song.path}");
		}
	}


	@override
	void dispose()
	{
		posSub.cancel();
		durSub.cancel();

		for (final wf in waveformCache.values) {
			wf.progress = 0.0;
			wf.duration = null;
		}

		playerDestroy(interface.player);
		super.dispose();
	}

	@override
	Widget build(BuildContext context)
	{
		final Responsive responsive = Responsive(context);

		return Scaffold(
			appBar: AppBar(title: const Text("Music Player")),
			body: (responsive.isMobile())
				? buildMobile(context)
				//: buildDesktop(context),
				: buildMobile(context)
		);
  	}

	Widget buildMobile(BuildContext context)
	{
		final Song? song = playerGetCurrentSong(interface.playback);

		WaveformInterface? wf;
		if (song != null) {
			wf = waveformCache["assets/${song.path}"];
			if (wf != null) wf.duration = interface.playback.duration;
		}

		final Responsive responsive = Responsive(context);

		// mobile break point at 600
		// full fize at 340
		// reduce to 240 linearly
		double t = (responsive.screenWidth / 600).clamp(0.0, 1.0);
		double coverWidth = _COVERSIZEMIN + (_COVERSIZEMAX - _COVERSIZEMIN) * t;
		coverWidth = coverWidth.clamp(_COVERSIZEMIN, _COVERSIZEMAX);
		double waveformWidth = coverWidth * 0.9;
		double waveformHeight = _WAVEFORMHEIGHT * (0.8 + 0.2 * t);

		return SingleChildScrollView(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					SongCover(song: song, size: coverWidth),
					SongInfo(song: song),
					if (wf != null)
					buildWaveform(wf, waveformHeight, waveformWidth),
					buildPlaybackControl(),
				],
			),
		);
	}


	Widget buildWaveform(WaveformInterface wf, double wfHeight, double wfWidth)
	{
		return SizedBox(
			width: wfWidth,
			height: wfHeight,
			child: Waveform(
				wf: wf,
				color: Color(0xff254887),
				overrideHeight: wfHeight,
				onSeek: (progress) {
					final newPos = Duration(
						milliseconds: (interface.playback.duration.inMilliseconds * progress).toInt(),
					);
					waveformSetProgress(wf!, progress);
					interface.player.seek(newPos);
					interface.playback.position = newPos;
					setState(() {});
				},
			),
		);
	}

	Widget buildPlaybackControl()
	{
		return PlaybackControl(
			playback: interface.playback,
			playSong: (index) async => await uiPlaySong(interface, index, () => setState(() {})),
			nextSong: () async => await uiNextSong(interface, () => setState(() {})),
			previousSong: () async => await uiPrevSong(interface, () => setState(() {})),
			shuffleSong: () async => await uiShuffleSong(interface, () => setState(() {})),
			togglePlayPause: () async => await uiTogglePlayPause(interface, () => setState(() {})),
			volume: volume,
			onVolumeChanged: onVolumeChanged
		);
	}
}

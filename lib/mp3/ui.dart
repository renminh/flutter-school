

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:palette_generator/palette_generator.dart';

import 'player.dart';
import 'types.dart';
import 'widgets/cover.dart';
import 'widgets/song_info.dart';
import 'widgets/control.dart';
import '../util/util.dart';

// mute the hsl so that it looks like amberol
// ignore: non_constant_identifier_names
Color MUTECOLOR(Color color, {double saturationFactor = 0.3, double brightnessFactor = 0.8})
{
	final hsl = HSLColor.fromColor(color);
	final muted = hsl.withSaturation(hsl.saturation * saturationFactor)
					.withLightness(hsl.lightness * brightnessFactor);
	return muted.toColor();
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});
  @override
  Mp3State createState() => Mp3State();
}

class Mp3State extends State<PlayerPage> {
	final AudioPlayer player = AudioPlayer();
	final Playback playback = Playback(songs: []);

	Color color1 = Colors.grey.shade800;
	Color color2 = Colors.grey.shade600;

	// cacheing is necessary cos it's so slow having to compute in real-time on every song change
	final Map<String, List<Color>> gradientCache = {};

	// no need to lazy load gradients
	Future<void> _songGradientCompte(Song song, Map cache) async
	{
		if (song.metadata.picture == null) {
			cache[song.path] = [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface];
			return;
		};

		final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
			ResizeImage(
				MemoryImage(song.metadata.picture!.bytes),
				width: 100, height: 100
			),
			maximumColorCount: 5
		);

		final Color color = palette.dominantColor?.color != null
			? palette.dominantColor!.color
			: Colors.grey.shade800;

		final Color color2 = palette.colors.length > 1
			? palette.colors.elementAt(1)
			: palette.dominantColor?.color ?? Colors.grey.shade600;
		cache[song.path] = [MUTECOLOR(color), MUTECOLOR(color2)];
	}

	Future<void> _precomputeGradients(Playback playback, Map cache) async {
		for (final Song song in playback.songs) {
			await _songGradientCompte(song, cache);
		}

		// gradient immediately on load
		final firstSong = playerGetCurrentSong(playback);
		if (firstSong != null && cache.containsKey(firstSong.path)) {
			setState(() {
				color1 = cache[firstSong.path]![0];
				color2 = cache[firstSong.path]![1];
			});
		}
	}

	// wrappers
	// no macro substitution, this the best we got :(
	// wrapC wraps state-changing functions with the update color and normal wrap only does the former
	Future<void> _wrapC(Future<void> Function() fn) async { await fn(); await _updateColors(gradientCache); setState(() {});}
	Future<void> _wrap(Future<void> Function() fn) async { await fn(); setState(() {}); }

	Future<void> playSong(int index) => _wrapC(() => playerPlay(player, playback, index));
	Future<void> togglePlayPause() => _wrap(() => playerTogglePlayPause(player, playback));
	Future<void> nextSong() => _wrapC(() => playerNext(player, playback));
	Future<void> previousSong() => _wrapC(() => playerPrevious(player, playback));
	Future<void> shuffleSong() => _wrapC(() => playerShuffle(player, playback));
	Future<void> _init() async
	{
		await playerInitialize(player, playback, SongRepository.songPaths);
		await _precomputeGradients(playback, gradientCache);
		setState(() {});
	}

	Future<void> _updateColors(Map cache) async
	{
		final song = playerGetCurrentSong(playback);
		if (song == null || song.metadata.picture == null) return;

		if (cache.containsKey(song.path)) {
			final colors = cache[song.path]!;
			setState(() {
				color1 = colors[0];
				color2 = colors[1];
			});
			return;
		}
	}
	@override
	void initState()
	{
		super.initState();
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
		appBar: AppBar(title: const Text("Music Player")),
		body: AnimatedContainer(
			duration: const Duration(milliseconds: 333),
			decoration: BoxDecoration(
				gradient: LinearGradient(
				colors: [color1, color2],
				begin: Alignment.topLeft,
				end: Alignment.bottomRight,
				),
			),
			child: Center(
				child: Mp3Card(
					playback: playback,
					nextSong: nextSong,
					previousSong: previousSong,
					shuffleSong: shuffleSong,
					togglePlayPause: togglePlayPause,
					playSong: playSong,
					),
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
		double screenWidth = MediaQuery.sizeOf(context).width;
		double coverMin = 220;
		double coverMax = 440;
		double coverSize = DCLAMP(coverMin, coverMax, screenWidth * 0.6);

		return Container(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					// https://api.flutter.dev/flutter/widgets/Image/Image.memory.html
					SongCover(song: playerGetCurrentSong(playback), size: coverSize),
					SongInfo(song: playerGetCurrentSong(playback)),
					PlaybackControl(
						playback: playback,
						nextSong: nextSong,
						previousSong: previousSong,
						shuffleSong: shuffleSong,
						togglePlayPause: togglePlayPause,
						playSong: playSong,
					),
				],
			),
		);
	}
}

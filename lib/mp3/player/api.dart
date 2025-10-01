// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:math';
import '../types.dart';
import '../../util/util.dart';


const int _SAMPLE_SIZE_COVER = 32;
const int _SAMPLE_SIZE_GRADIENT = 5;

class PlayerInterface {
	final AudioPlayer player;
	final Playback playback;
	final Map<String, List<Color>> gradientCache = {};

	Color color1 = Colors.grey.shade800;
	Color color2 = Colors.grey.shade600;

	PlayerInterface({
		required this.player,
		required this.playback
	});
}

/* --------------------------------------------------------------------------
 * apis for the actual logic without necessarily touching the UI
 * it's supposed to be used together with player_ui.dart in order
 * to interact and change the UI
 */

Future<void> playerInitialize(AudioPlayer player, Playback playback, List<String> songPaths) async
{
	await _GETSONGS(playback, songPaths);
	// preload the first song to avoid ui lagging behind
	// grabbing the songs to audioplayer and audiotags
	if (playback.songs.isNotEmpty) {
		await player.setSource(AssetSource(playback.songs[0].path));
		playback.songIndex = 0;
		playback.playing = false;
		playback.shuffle = false;
	}
}

Future<void> playerPlay(AudioPlayer player, Playback playback, int index) async
{
	index = ICLAMP(0, playback.songs.length - 1, index);
  	await player.stop();
  	await player.play(AssetSource(playback.songs[index].path));
  	playback.playing = true;
  	playback.songIndex = index;
}

 Future<void> playerNext(AudioPlayer player, Playback playback) async
{
  	int index = (playback.songIndex + 1) % playback.songs.length;
  	await playerPlay(player, playback, index);
}

Future<void> playerPrevious(AudioPlayer player, Playback playback) async
{
	int index = (playback.songIndex - 1) % playback.songs.length;
	await playerPlay(player, playback, index);
}

Future<void> playerTogglePlayPause(AudioPlayer player, Playback playback) async
{
	if (playback.playing) {
		await player.pause();
	} else {
		await player.resume();
	}
	playback.playing = !playback.playing;
}

Future<void> playerPause(AudioPlayer player, Playback playback) async
{
	if (playback.playing) {
		await player.pause();
		playback.playing = false;
	}
}

Future<void> playerResume(AudioPlayer player, Playback playback) async
{
	if (!playback.playing) {
		await player.resume();
		playback.playing = true;
	}
}

 Future<void> playerShuffle(AudioPlayer player, Playback playback) async
{
	if (playback.songs.length <= 1) return;

	int index = 0;

	do {
		index = Random().nextInt(playback.songs.length);
	} while (index == playback.songIndex);

	await playerPlay(player, playback, index);
}

Future<void> playerDestroy(AudioPlayer player) async
{
	await player.stop();
	await player.dispose();
}

Song? playerGetSong(Playback playback, int index)
{
	if (playback.songs.isEmpty) return null;
	index = ICLAMP(0, playback.songs.length - 1, index);
	return playback.songs[index];
}

Song? playerGetCurrentSong(Playback playback)
{
	return playerGetSong(playback, playback.songIndex);
}

Duration progressToDuration(Duration totalDuration, double progress)
{
	final clamped = DCLAMP(0.0, 1.0, progress);
	return Duration(milliseconds: (totalDuration.inMilliseconds * clamped).toInt());
}

/* --------------------------------------------------------------------------
 * apis for the ui wrappers that should be used whenever state-changing
 * functions require the UI to be rebuilt
 */

Future<void> uiPlaySong(PlayerInterface interface, int index, VoidCallback refresh) async
{
	await _WRAPUI(() => playerPlay(interface.player, interface.playback, index), refresh);
	_UPDATE_COLOR_GRADIENT(interface);
}

Future<void> uiNextSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerNext(interface.player, interface.playback), refresh);
	_UPDATE_COLOR_GRADIENT(interface);
}

Future<void> uiPrevSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerPrevious(interface.player, interface.playback), refresh);
	_UPDATE_COLOR_GRADIENT(interface);
}

Future<void> uiTogglePlayPause(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerTogglePlayPause(interface.player, interface.playback), refresh);
}

Future<void> uiShuffleSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerShuffle(interface.player, interface.playback), refresh);
	_UPDATE_COLOR_GRADIENT(interface);
}

Future<void> uiSeek(PlayerInterface interface, Duration pos, VoidCallback refresh) async
{
	await _WRAPUI(() => interface.player.seek(pos), refresh);
	interface.playback.position = pos;
}

Future<void> computeSongGradient(PlayerInterface interface, Song song) async
{
	if (song.metadata.picture == null) {
		interface.gradientCache[song.path] = [Colors.grey.shade800, Colors.grey.shade600];
		return;
	}

	final palette = await PaletteGenerator.fromImageProvider(
		ResizeImage(
			MemoryImage(song.metadata.picture!.bytes),
				width: _SAMPLE_SIZE_COVER,
				height: _SAMPLE_SIZE_COVER,
		),
		maximumColorCount: _SAMPLE_SIZE_GRADIENT,
	);

	final c1 = palette.dominantColor?.color ?? Colors.grey.shade800;
	final c2 = palette.colors.length > 1
		? palette.colors.elementAt(1)
		: palette.dominantColor?.color ?? Colors.grey.shade600;

  	interface.gradientCache[song.path] = [_MUTECOLOR(c1), _MUTECOLOR(c2)];
}


/* no need to look at these static functions :) */
Future<void> _GETSONGS(Playback playback, List<String> songPaths) async
{
	for (int i = 0; i < songPaths.length; i++) {
		// print("loading ${songPaths[i]}");
		Tag? tag = await AudioTags.read(songPaths[i]);
		SongMetadata metadata = SongMetadata(null, null, null, null, null);

		List<Picture>? pictures = tag?.pictures;
		metadata.picture = pictures?[0];
		metadata.title =		STR_OR(tag?.title, "Unknown Track");
		metadata.trackArtist =	STR_OR(tag?.trackArtist, "Unknown Artist");
		metadata.album =		STR_OR(tag?.album, "Unknown Album");
		metadata.year =			INT_OR(tag?.year, 1900);

		Song song = Song(metadata, songPaths[i].replaceFirst("assets/", ""));
		playback.songs.add(song);
	}
}

void _UPDATE_COLOR_GRADIENT(PlayerInterface interface)
{
	final song = playerGetCurrentSong(interface.playback);
	if (song == null) return;
	if (interface.gradientCache.containsKey(song.path)) {
		final colors = interface.gradientCache[song.path]!;
		interface.color1 = colors[0];
		interface.color2 = colors[1];
	}
}

Color _MUTECOLOR(Color color, {double saturationFactor = 0.3, double brightnessFactor = 0.8})
{
	final hsl = HSLColor.fromColor(color);
	final muted = hsl.withSaturation(hsl.saturation * saturationFactor)
		.withLightness(hsl.lightness * brightnessFactor);
	return muted.toColor();
}

/* generic wrapper to refresh UI using setState() */
Future<void> _WRAPUI(Future<void> Function() fn, VoidCallback refresh) async
{
	await fn();
	refresh();
}

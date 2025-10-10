// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'song.dart';
import '../../util/util.dart';

typedef PlayerHandle = AudioPlayer;

class PlayerInterface {
	final PlayerHandle player;
	final Playback playback;

	PlayerInterface({
		required this.player,
		required this.playback
	});
}

class Playback {
	final List<Song> songs;
	int songIndex;
	bool playing;
	bool shuffle;
	Duration position;
  	Duration duration;

	Playback({
		required this.songs,
		this.songIndex = 0,
		this.playing = false,
		this.shuffle = false,
		this.position = Duration.zero,
    	this.duration = Duration.zero,
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
		playback.duration = await player.getDuration() ?? Duration.zero;
		playback.position = Duration.zero;
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

/* --------------------------------------------------------------------------
 * apis for the ui wrappers that should be used whenever state-changing
 * functions require the UI to be rebuilt
 */

Future<void> uiPlaySong(PlayerInterface interface, int index, VoidCallback refresh) async
{
	await _WRAPUI(() => playerPlay(interface.player, interface.playback, index), refresh);
}

Future<void> uiNextSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerNext(interface.player, interface.playback), refresh);
}

Future<void> uiPrevSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerPrevious(interface.player, interface.playback), refresh);
}

Future<void> uiTogglePlayPause(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerTogglePlayPause(interface.player, interface.playback), refresh);
}

Future<void> uiShuffleSong(PlayerInterface interface, VoidCallback refresh) async
{
	await _WRAPUI(() => playerShuffle(interface.player, interface.playback), refresh);
}

Future<void> uiSeek(PlayerInterface interface, Duration pos, VoidCallback refresh) async
{
	await _WRAPUI(() => interface.player.seek(pos), refresh);
	interface.playback.position = pos;
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

/* generic wrapper to refresh UI using setState() */
Future<void> _WRAPUI(Future<void> Function() fn, VoidCallback refresh) async
{
	await fn();
	refresh();
}

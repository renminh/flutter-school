import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';

import 'dart:math';
import 'types.dart';

Future<void> playerInitialize(AudioPlayer player, Playback playback, List<String> songPaths) async
{
	await _getSongs(playback, songPaths);
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
	int min = 0;
  	int max = playback.songs.length - 1;
  	index = (index < min) ? min : (index > max) ? max : index;

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
	int index = 0;
	do {
		index = Random().nextInt(playback.songs.length);
	} while (index == playback.songIndex);

	await playerPlay(player, playback, index);
}

void playerDestroy(AudioPlayer player)
{
	player.stop();
}

Song? playerGetSong(Playback playback, int index)
{
	if (playback.songs.isEmpty) return null;

	int min = 0;
	int max = playback.songs.length - 1;
	index = (index < min) ? min : (index > max) ? max : index;
	return playback.songs[index];
}

Song? playerGetCurrentSong(Playback playback)
{
	return playerGetSong(playback, playback.songIndex);
}

/*
 * no need to look at these static functions:)
 */
Future<void> _getSongs(Playback playback, List<String> songPaths) async
{
	for (int i = 0; i < songPaths.length; i++) {
		Tag? tag = await AudioTags.read(songPaths[i]);
		SongMetadata metadata = SongMetadata(null, null, null, null, null);

		metadata.title = tag?.title != null ? tag!.title : "Unkown Track";
		metadata.trackArtist = tag?.trackArtist != null ? tag!.trackArtist : "Unknown Artist";
		metadata.album = tag?.album != null ? tag!.album : "Unkown Album";
		metadata.year = (tag?.year != null ? tag!.year : "Unkown Year") as int?;
		List<Picture>? pictures = tag?.pictures;
		metadata.picture = pictures?[0];

		Song song = Song(
		metadata,
		songPaths[i].replaceFirst("assets/", ""),
		);
		playback.songs.add(song);
	}
}

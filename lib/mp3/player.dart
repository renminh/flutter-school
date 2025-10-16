import 'package:app_lab/config.dart';
import 'package:app_lab/mp3/data/tracks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'song.dart';
import '../util/util.dart';
import 'dart:math';

class Mp3Player {
	AudioPlayer audio;
	List<Track> tracks = [];

	// this is real hacky but idk how to put a proper shuffle w/o reorganizing the way
	// tracks are handled such that i wouldn't need to create another array for a queue
	// or for the history
	List<Track> playlist_original = [];

	// volume is normalized from 0..1
	double volume;
	int current_index;
	bool playing;
	bool shuffled;

	Duration current_position;

	Mp3Player({
	 	required this.audio,
		this.current_index = 0,
		this.volume = 0.5,
		this.playing = false,
		this.shuffled = false,
		this.current_position = Duration.zero,
	});
}

Future<void> player_set_volume(Mp3Player player, double volume) async
{
	volume = CLAMPD(0, 1, volume);
	player.audio.setVolume(volume);
	player.volume = volume;
}

Future<void> player_load_tracks(Mp3Player player, List<TrackData> track_data) async
{
	for (int i = 0; i < track_data.length; i++) {
		Track t = track_create(track_data[i]);
		player.tracks.add(t);
		player.playlist_original.add(t);
	}

	if (player.tracks.length > 0) {
		await player.audio.setSource(AssetSource(player.tracks[0].path.replaceFirst("assets/", "")));
	}
}


Future<void> player_play(Mp3Player player, int index) async
{
	index = CLAMPI(0, player.tracks.length - 1, index);
	await player.audio.stop();
	await player.audio.play(AssetSource(player.tracks[index].path.replaceFirst("assets/", "")));
	player.playing = true;
	player.current_index = index;
}

Future<void> player_next(Mp3Player player) async
{
	int index = (player.current_index + 1) % player.tracks.length;
	await player_play(player, index);
}

Future<void> player_previous(Mp3Player player) async
{
	if (player.current_position.inSeconds > RESTART_THRESHOLD) {
		await player_pause(player);
		await player_play(player, player.current_index);
		player.current_position = Duration.zero;
		return;
	}
	int index = (player.current_index - 1) % player.tracks.length;
	await player_play(player, index);
}

Future<void> player_toggle_resume_pause(Mp3Player player) async
{
	if (player.playing) {
		await player_pause(player);
	} else {
		await player_resume(player);
	}
}

Future<void> player_pause(Mp3Player player) async
{
	if (player.playing) {
		await player.audio.pause();
		player.playing = false;
	}
}

Future<void> player_resume(Mp3Player player) async
{
	if (!player.playing) {
		await player.audio.resume();
		player.playing = true;
	}
}

Future<void> player_shuffle_on(Mp3Player player) async
{
	if (player.shuffled) return;

	player.shuffled = true;
	if (player.tracks.length < 1) return;

	// int div by 0 for some reason so i'll save state before doing it again
	// and keep track of current track before shuffling
	Track current_track = player_current_track(player);
	player.playlist_original = List.from(player.tracks);
	tracks_fisher_yates_shuffle(player.tracks);

	// need to modify it right after so that we're still on THAT song
	// index we're currently on inside the newly randomized array
	// this is cos i keep running on the same song when pressing ff once or rewind
	// and that the current track we're on isn't in the same index anymore
	// only side effect is the history isn't properly tracked when rewind is used :(
	// which means the only way of fixing this is to implement different arrays for queues,
	// playlist, and the history (as a stack)
	for (int i = 0; i < player.tracks.length; i++) {
		if (player.tracks[i].path == current_track.path) {
			player.current_index = i;
			break;
		}
	}
}

// shuffle off simply places back the original playlist with whatever song you currently
// were on as the current index in the original playlist
Future<void> player_shuffle_off(Mp3Player player) async
{
	if (!player.shuffled) return;

	player.shuffled = false;
	Track current_track = player_current_track(player);
	player.tracks = List.from(player.playlist_original);

	// find current track inside original playlist
	for (int i = 0; i < player.tracks.length; i++) {
		if (player.tracks[i].path == current_track.path) {
			player.current_index = i;
			break;
		}
	}
}

Future<void> player_shuffle_toggle(Mp3Player player) async
{
	if (player.shuffled) {
		player_shuffle_off(player);
	} else {
		player_shuffle_on(player);
	}
}

// https://stackoverflow.com/a/12646864
// https://bost.ocks.org/mike/shuffle/
// lists are passed by reference so no need to return
void tracks_fisher_yates_shuffle(List<Track> tracks)
{
	int current_index = tracks.length;

	while (current_index != 0) {
		int random_index = (Random().nextDouble() * current_index).floor();
		current_index--;

		Track temp = tracks[current_index];
		tracks[current_index] = tracks[random_index];
		tracks[random_index] = temp;
	}
}

Future<void> player_free(Mp3Player player) async
{
	await player.audio.stop();
	await player.audio.dispose();
}

Track player_track_get(Mp3Player player, int index)
{
	if (player.tracks.length <= index) {
		print("Index out of bounds while attempting to fetch track! clamping");
		index = CLAMPI(0, player.tracks.length - 1, index);
	}

	return player.tracks[index];
}

Track player_current_track(Mp3Player player)
{
	return player_track_get(player, player.current_index);
}

Future<void> player_seek_to(Mp3Player player, Duration position) async
{
	// pause to make seek reliable
	bool was_playing = player.playing;
	if (was_playing) {
		await player_pause(player);
	}

	await player.audio.seek(position);
	player.current_position = position;

	if (was_playing) {
		await player_resume(player);
	}
}

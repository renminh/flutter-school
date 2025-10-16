import 'package:app_lab/mp3/data/tracks.dart';
import 'package:flutter/widgets.dart';

const List<String> ASSET_SONGS = [
	'assets/music/palette.mp3',
	'assets/music/leia remind.mp3',
	'assets/music/epilogue.mp3',
	'assets/music/draw.mp3',
	'assets/music/Youre Beautiful.mp3',
	'assets/music/IVD0.mp3',
	'assets/music/make me cry.mp3',
	'assets/music/vivid.mp3',
	'assets/music/YY.mp3',
];

// On Mp3Metadata documentation
// there's barely anything inside sadly but the tag parser file is pretty well-documented
//https://pub.dev/documentation/audio_metadata_reader/latest/
class Track {
	String path;

	// metadata
	String title;
	String artist;
	Duration duration;
	String album;
	late final Image cover;

	Track(
		this.path,
		this.title,
		this.artist,
		this.duration,
		this.album,
	);
}

Track track_create(TrackData data)
{
	Track track = Track(data.path, data.title, data.artist, data.duration, data.album);
	print("created track: ${data.title}");
	track.cover = track_cover_build(track, data.cover_path);
	return track;
}

Image track_cover_build(Track t, String? path)
{
	if (path == null) {
		print("No picture was provided for track, fallback to default cover");
		return Image.asset("assets/icon/default_album_cover.jpeg");
	}

	return Image.asset(path, width: 128, height: 128);
}

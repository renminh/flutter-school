import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'dart:io';

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
	// picture just stores metadata bytes but not the actual finalized cover
	Picture? picture;
	late final Image cover;

	Track(
		this.path,
		this.title,
		this.artist,
		this.duration,
		this.album,
		this.picture
	);
}

Track track_create(String path)
{
	final loaded_file = File(path);
	AudioMetadata data = readMetadata(loaded_file, getImage: true);

	String title = data.title != null ? data.title! : "Unknown Title";
	String artist = data.artist != null ? data.artist! : "Unkown Artist";
	String album = data.album != null ? data.album! : "Unkown Album";
	Duration duration = data.duration != null ? data.duration! : Duration.zero;
	Picture? picture = data.pictures.isEmpty ? null : data.pictures[0];

	Track track = Track(path, title, artist, duration, album, picture);
	track.cover = track_cover_build(track);
	
	return track;
}

// using image bytes from data, we can construct the cover using flutter's Image.memory constructor
// It displays an image stream taken from an array of size Uint8
// https://stackoverflow.com/a/65615984
// https://api.flutter.dev/flutter/widgets/Image/Image.memory.html
Image track_cover_build(Track t)
{
	Picture? picture = t.picture;
	if (picture == null) {
		print("No picture was provided for track, fallback to default cover");
		return Image.asset("assets/icon/default_album_cover.jpeg");
	}

	return Image.memory(Uint8List.fromList(picture.bytes), width: 128, height: 128);
}

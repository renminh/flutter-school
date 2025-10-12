import 'package:audiotags/audiotags.dart';

const List<String> songPaths = [
	'assets/music/palette.mp3',
	'assets/music/leia remind.mp3',
	'assets/music/epilogue.mp3',
	'assets/music/draw.mp3',
	'assets/music/Youre Beautiful.mp3',
	'assets/music/IVD0.mp3',
	'assets/music/make me cry.mp3',
	'assets/music/vivid.mp3',
];

class Song {
	SongMetadata metadata;
	String path;

	Song(this.metadata, this.path);
}

class SongMetadata {
	String? title;
	String? trackArtist;
	String? album;
	int? year;
	Picture? picture;

	SongMetadata(
		this.title,
		this.trackArtist,
		this.album,
		this.year,
		this.picture,
	);
}

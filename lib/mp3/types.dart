import 'package:audiotags/audiotags.dart';

class SongRepository {
	static const List<String> songPaths = [
		'assets/music/Algo contigo.mp3',
		'assets/music/Eu desespero.mp3',
		'assets/music/Eu seu que vou te amar.mp3',
		'assets/music/Senhorinha.mp3',
	];
}

class Playback {
	final List<Song> songs;
	int songIndex;
	bool playing;
	bool shuffle;

	Playback({
		required this.songs, 
		this.songIndex = 0,
		this.playing = false,
		this.shuffle = false 
	});
}

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

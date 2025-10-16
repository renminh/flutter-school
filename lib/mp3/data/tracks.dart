class TrackData {
	String title;
	final String path;
	String? cover_path;
	String artist;
	String album;
	final Duration duration;

	TrackData({
		this.title = "Unknown Title",
		required this.path,
		this.artist = "Unknown Artist",
		this.cover_path,
		this.album = "Unknown Album",
		required this.duration
	});
}

List<TrackData> TRACK_DATA = [
	TrackData(
		title: "Palette",
		path: 'assets/music/palette.mp3',
		artist: 'Yuyoyuppe',
		cover_path: 'assets/music/cover/palette.png',
		album: 'Solitude Freak',
		duration: Duration(seconds: 231),
	),

	TrackData(
		title: "Leia",
		path: "assets/music/leia remind.mp3",
		artist: 'Yuyoyuppe',
		album: 'Draw',
		duration: Duration(seconds: 254),
		cover_path: 'assets/music/cover/leia.png',
	),

	TrackData(
		title: "Draw",
		path: "assets/music/draw.mp3",
		artist: 'Yuyoyuppe',
		album: 'Draw',
		duration: Duration(seconds: 243),
		cover_path: 'assets/music/cover/draw.png',
	),

	TrackData(
		title: "You're Beautiful",
		path: "assets/music/Youre Beautiful.mp3",
		artist: 'Okame-P',
		album: 'A Peaceful Death',
		duration: Duration(seconds: 217),
		cover_path: 'assets/music/cover/peace.png',
	),

	TrackData(
		title: "IV-D-0",
		path: "assets/music/IVD0.mp3",
		artist: 'Okame-P',
		album: 'Then memory echoes softly',
		duration: Duration(seconds: 300),
		cover_path: 'assets/music/cover/iv.png',
	),

	TrackData(
		title: "make me cry",
		path: "assets/music/make me cry.mp3",
		artist: 'Okame-P',
		album: 'Lamento',
		duration: Duration(seconds: 233),
		cover_path: 'assets/music/cover/lamento.png',
	),

	TrackData(
		title: "vivid",
		path: "assets/music/vivid.mp3",
		artist: 'Utsu-P, Yuyoyuppe',
		album: 'UNIQUE',
		duration: Duration(seconds: 213),
	),

	TrackData(
		title: "cherry blossom",
		artist: "i9bonsai",
		path: "assets/music/cherry blossom.mp3",
		cover_path: "assets/music/cover/seedling.png",
		duration: Duration(seconds: 187),
	),

	TrackData(
		title: "let it out",
		artist: "i9bonsai",
		path: "assets/music/let.mp3",
		cover_path: "assets/music/cover/let.png",
		duration: Duration(seconds: 156),
	),
];

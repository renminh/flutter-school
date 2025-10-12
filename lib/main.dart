import 'package:app_lab/config.dart';
import 'package:flutter/material.dart';
import 'theme/dark.dart';
import 'secret.dart';
import 'mp3/ui/player.dart' show PlayerPage;
import 'common/activity_card.dart';
void main() =>	runApp(const MainApp());

class MainApp extends StatelessWidget {
	const MainApp({super.key});

	@override
	Widget build(BuildContext context)
	{
		const String app_title = 'Flutter Demo for Mobile Development';

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: darkMode,
			title: app_title,
			home: Home(),
		);
	}
}

class Home extends StatelessWidget {
	const Home({super.key});

	@override
	Widget build(BuildContext context)
	{
		final screen_width = MediaQuery.sizeOf(context).width;

		return Scaffold(
			backgroundColor: Theme.of(context).colorScheme.surface,
			appBar: HomeAppBar(),
			body: screen_width < MOBILE_MAX_WIDTH
				? build_mobile(context)
				: build_mobile(context),
		);
	}
}

Widget build_mobile(context)
{
	return GridView.count(
		primary: false,
			padding: EdgeInsets.all(12),
			mainAxisSpacing: 10,
			childAspectRatio: 1.3,
			crossAxisSpacing: 10,
			crossAxisCount: 1,
			children: build_grid_children(context),
	);
}

Widget build_desktop(context)
{
	return GridView.count(
		primary: false,
			padding: EdgeInsets.all(20),
			mainAxisSpacing: 10,
			childAspectRatio: 1,
			crossAxisSpacing: 10,
			crossAxisCount: 2,
			children: build_grid_children(context),
	);
}

List<Widget> build_grid_children(BuildContext context)
{

	return <Widget>[
		ActivityCard(
			color: Color(0xff254887),
			iconPath: "assets/icon/music.png",
			cardHeader: "Music Player",
			cardDescription: "Play and listen to music using flutter",
			onTap: () {
				Navigator.push(
					context,
					MaterialPageRoute<void>(
						builder: (context) => PlayerPage(),
					),
				);
			},
		),

		ActivityCard(
			color: Color(0xff254887),
			iconPath: "assets/icon/none1.png",
			cardHeader: "Activity 2",
			cardDescription: "Currently WIP",
		),


		ActivityCard(
			color: Color(0xff254887),
			iconPath: "assets/icon/none2.png",
			cardHeader: "Activity 3",
			cardDescription: "Currently WIP",
		),


		ActivityCard(
			color: Color(0xff254887),
			iconPath: "assets/icon/none3.png",
			cardHeader: "Activity 3",
			cardDescription: "Currently WIP",
		),
	];
}
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  	const HomeAppBar({super.key});

  	// thanks
  	// https://medium.com/@hpatilabhi10/taking-control-mastering-custom-app-bars-with-preferredsizewidget-in-flutter-b922f03dadf2
  	@override
  	Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  	@override
  	Widget build(BuildContext context)
  	{
		return AppBar(
			title: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(SecretText.header),
					Text(
						SecretText.headerSubtitle,
						style: TextStyle(fontSize: 12)
					),
				],
			),
			leadingWidth: 100,
		);
  	}
}

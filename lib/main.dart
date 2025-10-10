import 'package:flutter/material.dart';
import 'package:app_lab/util/responsive.dart';
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
		const String appTitle = 'Flutter app for uni';

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: darkMode,
			title: appTitle,
			home: Home(),
		);
	}
}

class Home extends StatelessWidget {
	const Home({super.key});

	@override
	Widget build(BuildContext context)
	{
		final responsive = Responsive(context);

		return Scaffold(
			backgroundColor: Theme.of(context).colorScheme.surface,
			appBar: HomeAppBar(),
			body: GridView.count(
				primary: false,
				padding: responsivePadding(responsive.screenWidth),
				mainAxisSpacing: 10,
				childAspectRatio:  responsive.isMobile() ? 1.0 : 1.3,
				crossAxisSpacing: 10,
				crossAxisCount: responsiveGridAxisCount(responsive.screenWidth),
				children: buildGridChildren(context, 16),
			)
		);
	}
}

EdgeInsets responsivePadding(double width)
{
	return width < 800
		? EdgeInsets.all(12)
		: EdgeInsets.symmetric(horizontal: 86, vertical: 16);
}

double responsiveFontSize(double width)
{
	return width < 600
		? 16
		: 20;
}

int responsiveGridAxisCount(double width)
{
	return width < 500
		? 1
		: 2;
}

List<Widget> buildGridChildren(BuildContext context, double dynamicFontSize)
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
			// backgroundColor: ColorPalette.header,
			// leading: Icon(Icons.account_circle),
			leadingWidth: 100,
		);
  	}
}

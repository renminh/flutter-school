import 'package:flutter/material.dart';


import 'pages/activity_four.dart' show ActivityFourPage;
import 'pages/activity_three.dart' show ActivityThreePage;
import 'pages/activity_two.dart' show ActivityTwoPage;
import 'mp3/player_page.dart' show PlayerPage;
  
import 'common/activity_button.dart';
import 'theme.dart';
import 'secret.dart';

void main() 
{
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
	const MainApp({super.key});
	@override
	Widget build(BuildContext context)
	{
		const String appTitle = 'Flutter app for uni';

		return MaterialApp(
			debugShowCheckedModeBanner: false,
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
		return Scaffold(
		backgroundColor: ColorPalette.backgroundDark,
		appBar: HomeAppBar(),
		body: HomeButtons(),
		);
	}
}

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context)
  {

    return GridView.count(
      primary: false,
      mainAxisSpacing: 20.0,
      padding: EdgeInsets.all(25.0),
      crossAxisSpacing: 20.0,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: <Widget>[
        ActivityButton(
          color: ColorPalette.page1, 
          destinationRoute: PlayerPage(),
          text: "Music Player",
          description: "...",
        ),

        ActivityButton(
          color: ColorPalette.page2, 
          destinationRoute: ActivityTwoPage(),
          text: "Activity 2",
          description: "This is special because it has the second activity",
        ),

        ActivityButton(
          color: ColorPalette.page3, 
          destinationRoute: ActivityThreePage(),
          text: "Activity 3",
          description: "This one is not as special since it's the third activity",
        ),

        ActivityButton(
          color: ColorPalette.page4, 
          destinationRoute: ActivityFourPage(),
          text: "Activity 4",
          description: "This one was just added because there needed to be a fourth",
        ),
      ],
    );
  }
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
      backgroundColor: ColorPalette.header,
      leading: Icon(Icons.account_circle),
      foregroundColor: ColorPalette.textLight,
      leadingWidth: 100,
    );
  }
}

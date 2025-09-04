import 'package:flutter/material.dart';

import 'index.dart';
import 'widgets/activity_button.dart';

import 'constants/theme.dart';
import 'constants/secret.dart';
/*
 * internal documentation for flutter for self learning
 * general flutter directory structure can be followed here
 * https://docs.flutterflow.io/generated-code/project-structure/
 * 
 * everything is a widget, even the layouts, and especially the App
 * https://docs.flutter.dev/ui/layout
 * 
 * stateless widget is a widget that contains children and has no mutable state
 */ 

void main() {
  runApp(const MainApp());
}

/*
 * necessary to seperate main app and MaterialApp because
 * of builder context that Navigator uses. Navigator
 * shouldn't be in the same level with MaterialApp
 * https://github.com/flutter/flutter/issues/15919
 */
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter app for uni';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  /* 
   * context is an instance of BuildContext, that is
   * it's the location of the widget in the widget tree
   */
  const Home({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundDark,
      appBar: AppBar(
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
      ),
      body: HomeButtons(),
    );
  }
}

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {

    /*
     * getting the size of the window can be used from the MediaQuery class
     * https://onlyflutter.com/how-to-get-the-screen-size-in-flutter/
     * https://api.flutter.dev/flutter/widgets/MediaQueryData-class.html
     */
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    /* 
     * this is so infuriating, if grid view does not respect the parent widget's constrains,
     * then i should just create a container widget that holds row and columns and then
     * have the buttons adjus according to it
     */
    return GridView.count(
      primary: false,
      mainAxisSpacing: 20.0,
      padding: EdgeInsets.all(25.0),
      crossAxisSpacing: 20.0,
      crossAxisCount: 2,
      /* 
        * TODO: read about this since i don't fully understand it yet
        * https://api.flutter.dev/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount/childAspectRatio.html
        */
      childAspectRatio: 1.5,
      children: <Widget>[
        ActivityButton(
          color: ColorPalette.page1, 
          destinationRoute: MusicPlayerPage(),
          text: "Music Player",
          description: "This contains everything about the first activity",
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
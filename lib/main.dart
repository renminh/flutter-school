import 'package:flutter/material.dart';

import 'index.dart';
import 'components/activity_button_widget.dart';
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 54, 52, 51),
      appBar: AppBar(
        title: Text("App by me"),
        backgroundColor: const Color.fromARGB(255, 76, 74, 73),
        leading: Icon(Icons.account_circle),
        foregroundColor: Colors.white,
        leadingWidth: 100,
      ),
      body: Center(

        /*
         * we can use GridView widget to have multiple children displayed as a grid
         * https://api.flutter.dev/flutter/widgets/GridView-class.html
         */
        child: Container(
          width: 500.0, // ideally i should clamp it depending on the screen size
          //height: 500.0, // no need to set the size
          child: GridView.count(
          primary: false,
          mainAxisSpacing: 20.0,
          padding: EdgeInsets.all(25.0),
          crossAxisSpacing: 20.0,
          crossAxisCount: 2,
          children: <Widget>[

            /* 
             * this is actually so terrible, making a page widget as a parent from a
             * parent widget. this is not ideally
             */
            ActivityButton(
              color: Colors.green, 
              destinationRoute: ActivityPageRoute(
                appBar: AppBar(
                  title: Text("nature"),
                  backgroundColor: const Color.fromARGB(255, 122, 145, 123),
                  leading: Icon(Icons.account_circle),
                  foregroundColor: Colors.white,
                  leadingWidth: 100,
                ),
                buttonColor: Colors.green,
                buttonText: "hi from green! go back home!"
              ), 
              text: "Click me to head to the green button!",
            ),

            ActivityButton(
              color: Colors.blue, 
              destinationRoute: ActivityPageRoute(
                appBar: AppBar(
                  title: Text("sea"),
                  backgroundColor: const Color.fromARGB(255, 100, 151, 162),
                  leading: Icon(Icons.account_circle),
                  foregroundColor: Colors.white,
                  leadingWidth: 100,
                ),
                buttonColor: Colors.blue,
                buttonText: "hi from blue! go back home!"
              ), 
              text: "Click me to head to the blue button!",
            ),

            ActivityButton(
              color: Colors.red, 
              destinationRoute: ActivityPageRoute(
                appBar: AppBar(
                  title: Text("fire"),
                  backgroundColor: const Color.fromARGB(255, 129, 22, 22),
                  leading: Icon(Icons.account_circle),
                  foregroundColor: Colors.white,
                  leadingWidth: 100,
                ),
                buttonColor: Colors.red,
                buttonText: "hi from red! go back home!"
              ),  
              text: "Click me to head to the red button!",
            ),

            ActivityButton(
              color: Colors.orange, 
              destinationRoute: ActivityPageRoute(
                appBar: AppBar(
                  title: Text("sun"),
                  backgroundColor: const Color.fromARGB(255, 139, 61, 22),
                  leading: Icon(Icons.account_circle),
                  foregroundColor: Colors.white,
                  leadingWidth: 100,
                ),
                buttonColor: Colors.orange,
                buttonText: "hi from orange! go back home!"
              ),  
              text: "Click me to head to the orange button!",
            ),
          ],
        ),
        ),
      ),
    );
  }
}


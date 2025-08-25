import 'package:flutter/material.dart';
import 'index.dart';

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
      body: Center(

        /*
         * we can use GridView widget to have multiple children displayed as a grid
         * https://api.flutter.dev/flutter/widgets/GridView-class.html
         */
        child: GridView.count(
          primary: false,
          crossAxisCount: 2,
          children: <Widget>[
            ActivityButton(
              "Click me to head to the green page!",
              Colors.green,
              destinationRoute: GreenRoute()
            ),

            ActivityButton(
              "Click me to head to the red page!",
              Colors.red,
              destinationRoute: GreenRoute()
            ),

            ActivityButton(
              "Click me to head to the blue page!",
              Colors.blue,
              destinationRoute: GreenRoute()
            ),

            ActivityButton(
              "Click me to head to the orange page!",
              Colors.orange,
              destinationRoute: GreenRoute()
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * ActivityButton contains the destination route(it'll be passed as an argument during construction)
 * https://stackoverflow.com/questions/71407657/flutter-how-to-pass-a-widget-as-a-parameter
 * 
 * navigation will be done via the  Navigator widget that manages a set of children widgets in a
 * FILO manner(stack) using push and pop
 * https://api.flutter.dev/flutter/widgets/Navigator-class.html
 * docs.flutter.dev/cookbook/navigation/navigation-basics
 */
class ActivityButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final Widget destinationRoute;

  const ActivityButton(this.buttonText, this.color, {super.key, required this.destinationRoute});

  @override
  Widget build(BuildContext context) {
    /* 
     * styling an ElevatedButton widget
     * https://www.kindacode.com/article/working-with-elevatedbutton-in-flutter
     */
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => destinationRoute,
          ),
        );
      }, 
      child: Text(buttonText)
    );
  }
}
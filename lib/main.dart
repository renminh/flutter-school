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
  /* 
   * context is an instance of BuildContext, that is
   * it's the location of the widget in the widget tree
   */
  const HomeScreen({super.key});
  
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

    return Scaffold(
      appBar: AppBar(
        title: Text("App by me"),
        backgroundColor: Color(0xff1D2021),
        leading: Icon(Icons.account_circle),
        foregroundColor: Color(0xffFBF1C7),
        leadingWidth: 100,
      ),
      body: Container(
        height: height,
        width: width,
        color: Color(0xff282828),
        /*
         * we can use GridView widget to have multiple children displayed as a grid
         * https://api.flutter.dev/flutter/widgets/GridView-class.html
         */
        child: SizedBox(
          width: 100,
          height: 50,
          child: GridView.count(
            primary: false,
            mainAxisSpacing: 20.0,
            padding: EdgeInsets.all(25.0),
            crossAxisSpacing: 20.0,
            crossAxisCount: 2,
            /* 
             * TODO: read about this since i don't fully understand it yet
             * https://api.flutter.dev/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount/childAspectRatio.html
             */
            childAspectRatio: 4,
            children: <Widget>[
              ActivityButton(
                color: Color(0xff458588), 
                destinationRoute: HardwarePage(),
                text: "Hardware",
              ),

              ActivityButton(
                color: Color(0xff98971A), 
                destinationRoute: ResourcePage(),
                text: "Resources",
              ),

              ActivityButton(
                color: const Color(0xffCC2412), 
                destinationRoute: OSDevelopmentPage(),
                text: "OS Development",
              ),

              ActivityButton(
                color: Color(0xffD79921), 
                destinationRoute: LanguagesPage(),
                text: "Languages",
              ),
            ],
          ),
        ),
      )
    );
  }
}


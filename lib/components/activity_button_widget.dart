import 'package:flutter/material.dart';
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
  final Color color;
  final Widget destinationRoute;
  final String text;

  const ActivityButton({
    super.key,
    required this.color,
    required this.destinationRoute, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    /* 
     * In order to adjust the size of buttons, there must be a parent
     * widget that can hold it, i'm using SizedBox as the child is forced
     * to have its specific height and width constraints
     * https://api.flutter.dev/flutter/widgets/SizedBox-class.html
     * 
     * SizedBox.expand constructor can be used to fit the child to the parent
     * 
     * and for styling an TextButton widget
     * https://api.flutter.dev/flutter/material/TextButton-class.html
     */
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(
              Radius.elliptical(10, 10)
            )
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => destinationRoute,
            ),
          );
        }, 
        child: Text(
          text,
          style: TextStyle(color: Color(0xffFBF1C7))
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../constants/theme.dart';
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
  final String description;

  const ActivityButton({
    super.key,
    required this.color,
    required this.destinationRoute, 
    required this.text,
    required this.description,
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
        
        child: _ActivityButtonContent(
          text: text,
          description: description
        )
      ),
    );
  }
}

/*
 * i don't wanna expose this anywhere else so it's private
 * https://www.geeksforgeeks.org/dart/how-to-create-private-class-in-dart/
 */
class _ActivityButtonContent extends StatelessWidget {
  final String text;
  final String description;

  const _ActivityButtonContent({
    super.key,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    /* https://api.flutter.dev/flutter/widgets/Align-class.html */
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(
              color: ColorPalette.textLight,
              fontSize: 20,
            )
          ),
          Text(
            description,
            style: TextStyle(
              color: ColorPalette.textLightSubtitle,
              fontSize: 13,
            )
          )
        ],
      ),
    );
  }
}